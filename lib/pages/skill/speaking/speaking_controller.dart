import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../models/skill/speaking/content_item_speaking_model.dart';
import '../../../models/skill/writing/writing_submit_request_model.dart';
import 'speaking_repository.dart';

class SpeakingController extends GetxController {
  final SpeakingRepository repo = SpeakingRepository();
  final stt.SpeechToText speech = stt.SpeechToText();

  var isLoadingQuestion = false.obs;
  var isCheckingAnswer = false.obs;
  var isRecording = false.obs;
  var isInitializingSpeech = false.obs;

  var question = Rxn<ContentItemSpeaking>();
  var score = Rxn<int>();
  var comment = Rxn<String>();
  var contentIds = <String>[].obs;
  var userScores = <int>[].obs;
  var userFeedbacks = <String>[].obs;
  var hasAnsweredCurrent = false.obs;

  late String skillId, levelId, skillName, levelName, topicId;
  int currentIndex = 0;
  String userTranscript = "";
  bool speechAvailable = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    skillId = args['skill_id'];
    levelId = args['level_id'];
    skillName = args['skill_name'];
    levelName = args['level_name'];
    topicId = args['topic_id'];

    initializeSpeech();
    loadContentIdsAndFirstQuestion();
  }

  @override
  void onClose() {
    speech.stop();
    super.onClose();
  }

  Future<void> initializeSpeech() async {
    isInitializingSpeech.value = true;
    try {
      speechAvailable = await speech.initialize(
        onError: (error) => print('Speech error: $error'),
        onStatus: (status) => print('Speech status: $status'),
      );
      if (!speechAvailable) {
        Get.snackbar(
          "Cảnh báo",
          "Không thể khởi tạo nhận diện giọng nói. Vui lòng kiểm tra quyền microphone.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
        );
      }
    } catch (e) {
      print("Error initializing speech: $e");
      Get.snackbar(
        "Lỗi",
        "Không thể khởi tạo nhận diện giọng nói: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isInitializingSpeech.value = false;
    }
  }

  Future<void> loadContentIdsAndFirstQuestion() async {
    isLoadingQuestion.value = true;
    try {
      contentIds.value = await repo.getAllContentIdsByTopic(topicId);
      if (contentIds.isNotEmpty) {
        userScores.value = List.filled(contentIds.length, 0);
        userFeedbacks.value = List.filled(contentIds.length, '');
        await loadSpeakingQuestion(contentIds[currentIndex]);
      } else {
        Get.snackbar("Thông báo", "Không tìm thấy câu hỏi nào cho chủ đề này");
      }
    } catch (e) {
      print("Error loading content IDs: $e");
      Get.snackbar("Lỗi", "Không thể tải danh sách câu hỏi: $e");
    } finally {
      isLoadingQuestion.value = false;
    }
  }

  Future<void> loadSpeakingQuestion(String contentId) async {
    isLoadingQuestion.value = true;
    try {
      question.value = await repo.getSpeakingDetail(contentId);
    } catch (e) {
      print("Error loading speaking question: $e");
      Get.snackbar("Lỗi", "Không thể tải câu hỏi: $e");
    } finally {
      isLoadingQuestion.value = false;
    }
  }

  void nextQuestion() {
    if (currentIndex < contentIds.length - 1) {
      currentIndex++;
      _loadAndReset();
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      _loadAndReset();
    }
  }

  void _loadAndReset() {
    loadSpeakingQuestion(contentIds[currentIndex]);
    userTranscript = "";
    hasAnsweredCurrent.value = false;

    if (userScores[currentIndex] > 0) {
      score.value = userScores[currentIndex];
      comment.value = userFeedbacks[currentIndex];
      hasAnsweredCurrent.value = true;
    } else {
      score.value = null;
      comment.value = null;
    }
  }

  Future<void> startRecording() async {
    if (!speechAvailable) {
      Get.snackbar(
        "Lỗi",
        "Nhận diện giọng nói không khả dụng",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    if (hasAnsweredCurrent.value) {
      Get.snackbar(
        "Thông báo",
        "Bạn đã kiểm tra câu này rồi!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isRecording.value = true;
    userTranscript = "";

    await speech.listen(
      onResult: (result) {
        userTranscript = result.recognizedWords;
      },
      listenFor: Duration(minutes: 2),
      pauseFor: Duration(seconds: 5),
      partialResults: true,
      localeId: 'en_US',
    );
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    await speech.stop();
    isRecording.value = false;

    if (userTranscript.trim().isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Không nhận diện được giọng nói. Vui lòng thử lại!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    // Tự động gửi để chấm điểm
    await checkAnswer(userTranscript);
  }

  Future<void> checkAnswer(String transcript) async {
    if (transcript.trim().isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Không có nội dung để chấm điểm!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    if (hasAnsweredCurrent.value) {
      Get.snackbar(
        "Thông báo",
        "Bạn đã kiểm tra câu này rồi!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isCheckingAnswer.value = true;

    const apiKey = "yourAPIKey";
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=$apiKey');
    final level = levelName.toUpperCase();

    String prompt;
    if (level == 'BEGINNER') {
      prompt = '''
Bạn là giáo viên tiếng Anh. Hãy chấm bài nói của học sinh cấp độ BEGINNER dựa trên văn bản transcript.

Đề bài: ${question.value?.body_text ?? ''}

${question.value?.media_audio_url != null ? 'Yêu cầu: Đọc lại đoạn văn được cung cấp.' : 'Yêu cầu: Trả lời câu hỏi bằng lời nói.'}

Bài làm của học sinh (transcript từ giọng nói): "$transcript"

Tiêu chí chấm (dựa trên text):
1. Từ vựng đơn giản phù hợp (Vocabulary) - 40%
2. Ngữ pháp cơ bản (Grammar) - 30%
3. Nội dung phù hợp với đề bài (Content) - 30%

LƯU Ý QUAN TRỌNG:
- Đây là bài nói đã chuyển thành text, nên KHÔNG chấm phát âm
- Chấm điểm từ 1-10, TUYỆT ĐỐI KHÔNG cho 0 điểm trừ khi hoàn toàn không liên quan
- Nếu học sinh cố gắng trả lời, tối thiểu 3-4 điểm
- Khích lệ và nhẹ nhàng trong nhận xét

Trả về JSON (CHỈ JSON, không thêm text):
{
  "score": <điểm 1-10, số nguyên>,
  "comment": "<nhận xét ngắn gọn bằng tiếng Việt: điểm mạnh, điểm yếu, gợi ý cải thiện>"
}
''';
    } else if (level == 'INTERMEDIATE') {
      prompt = '''
Bạn là giáo viên tiếng Anh. Chấm bài nói của học sinh cấp độ INTERMEDIATE dựa trên transcript.

Đề bài: ${question.value?.body_text ?? ''}

${question.value?.media_audio_url != null ? 'Yêu cầu: Đọc lại đoạn văn với câu hoàn chỉnh.' : 'Yêu cầu: Trả lời câu hỏi với các câu hoàn chỉnh.'}

Bài làm (transcript): "$transcript"

Tiêu chí chấm (dựa trên text):
1. Từ vựng đa dạng (Vocabulary range) - 30%
2. Ngữ pháp chính xác (Grammar accuracy) - 30%
3. Độ phong phú câu văn (Sentence variety) - 20%
4. Tính mạch lạc & liên kết (Coherence & Cohesion) - 20%

LƯU Ý QUAN TRỌNG:
- Đây là transcript từ giọng nói, KHÔNG chấm phát âm
- Chấm từ 1-10, cho điểm dựa trên chất lượng nội dung và ngữ pháp
- Nếu có cố gắng sử dụng cấu trúc phức tạp, tối thiểu 4-5 điểm
- Khích lệ nhưng chỉ ra điểm cần cải thiện rõ ràng

Trả về JSON (CHỈ JSON):
{
  "score": <điểm 1-10>,
  "comment": "<nhận xét bằng tiếng Việt: ưu điểm, điểm cần cải thiện, lời khuyên cụ thể>"
}
''';
    } else {
      // ADVANCED
      prompt = '''
Bạn là giáo viên tiếng Anh chuyên nghiệp. Chấm bài nói cấp độ ADVANCED dựa trên transcript.

Đề bài: ${question.value?.body_text ?? ''}

Yêu cầu: Trình bày ý kiến trong 1-2 phút với lập luận rõ ràng.

Bài làm (transcript): "$transcript"

Tiêu chí chấm (theo chuẩn IELTS Speaking - dựa trên text):
1. Từ vựng học thuật, idioms, collocations (Lexical Resource) - 30%
2. Ngữ pháp phức tạp, đa dạng thì và cấu trúc (Grammatical Range) - 30%
3. Mạch lạc, lập luận logic, liên kết tốt (Coherence & Cohesion) - 25%
4. Độ phong phú ý tưởng và triển khai (Content Development) - 15%

LƯU Ý QUAN TRỌNG:
- Đây là transcript, KHÔNG đánh giá phát âm
- Chấm từ 1-10 dựa trên chất lượng ngôn ngữ và nội dung
- Cấp độ cao nên yêu cầu strict hơn, nhưng nếu có cố gắng tối thiểu 5 điểm
- Nhận xét chuyên sâu, cụ thể từng tiêu chí

Trả về JSON (CHỈ JSON):
{
  "score": <điểm 1-10>,
  "comment": "<nhận xét chuyên sâu bằng tiếng Việt: phân tích chi tiết từng tiêu chí, lỗi cụ thể, hướng cải thiện>"
}
''';
    }

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": level == 'BEGINNER' ? 0.3 : 0.7,
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 1024,
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("Gemini API Status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

        print("Gemini response text: $text");

        String cleanedText = text.trim();
        if (cleanedText.startsWith('```json')) {
          cleanedText = cleanedText.substring(7);
        }
        if (cleanedText.startsWith('```')) {
          cleanedText = cleanedText.substring(3);
        }
        if (cleanedText.endsWith('```')) {
          cleanedText = cleanedText.substring(0, cleanedText.length - 3);
        }
        cleanedText = cleanedText.trim();

        print("Cleaned text: $cleanedText");

        try {
          final result = jsonDecode(cleanedText);
          int rawScore = result['score'] is int ? result['score'] : 0;

          // Đảm bảo điểm tối thiểu là 1 (trừ khi AI trả về 0 có chủ đích)
          int finalScore = rawScore == 0 ? 3 : rawScore.clamp(1, 10);

          String cleanComment = (result['comment'] ?? "Không có nhận xét")
              .replaceAll('*', '')
              .replaceAll('**', '')
              .trim();

          score.value = finalScore;
          comment.value = cleanComment;

          userScores[currentIndex] = finalScore;
          userFeedbacks[currentIndex] = cleanComment;
          hasAnsweredCurrent.value = true;

          await _submitSingleResult(finalScore, cleanComment);

          final color = finalScore >= 8
              ? Colors.green.shade100
              : finalScore >= 5
              ? Colors.orange.shade100
              : Colors.red.shade100;

          Get.snackbar(
            "Hoàn thành",
            "Điểm: $finalScore/10 - Đã lưu kết quả!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: color,
            duration: const Duration(seconds: 3),
          );
        } catch (e) {
          print("JSON parse error: $e");
          score.value = 5;
          comment.value = "Không thể phân tích phản hồi từ AI. Text gốc: $cleanedText";

          Get.snackbar(
            "Cảnh báo",
            "Đã nhận được phản hồi nhưng định dạng không chuẩn",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade100,
          );
        }
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error checking speaking answer: $e");
      Get.snackbar(
        "Lỗi",
        "Không thể chấm điểm. Vui lòng thử lại. Chi tiết: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isCheckingAnswer.value = false;
    }
  }

  Future<void> _submitSingleResult(int scoreValue, String feedback) async {
    try {
      final currentContentId = contentIds[currentIndex];

      final request = WritingSubmitRequest(
        topic_id: topicId,
        content_item_id: currentContentId,
        score: scoreValue.toDouble(),
        feedback: feedback.isEmpty ? "Không có nhận xét." : feedback,
      );

      print("Submitting speaking result: ${request.toJson()}");

      await repo.receiveResult(request);

      print("Speaking result submitted successfully for content: $currentContentId");
    } catch (e) {
      print("Error submitting speaking result: $e");
    }
  }

  Future<void> finishTopic() async {
    Get.back();
  }
}