import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/skill/writing/content_item_writing_model.dart';
import '../../../models/skill/writing/writing_submit_request_model.dart';
import 'writing_repository.dart';


class WritingController extends GetxController {
  final WritingRepository repo = WritingRepository();

  var isLoadingQuestion = false.obs;
  var isCheckingAnswer = false.obs;
  var isSubmitting = false.obs;
  var hasSubmitted = false.obs;

  var question = Rxn<ContentItemWriting>();
  var score = Rxn<int>();
  var comment = Rxn<String>();
  var contentIds = <String>[].obs;
  var userScores = <int>[].obs;
  var userFeedbacks = <String>[].obs;
  var hasAnsweredCurrent = false.obs;

  late String skillId, levelId, skillName, levelName, topicId;
  int currentIndex = 0;
  String userAnswer = "";
  final textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    skillId = args['skill_id'];
    levelId = args['level_id'];
    skillName = args['skill_name'];
    levelName = args['level_name'];
    topicId = args['topic_id'];

    loadContentIdsAndFirstQuestion();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  Future<void> loadContentIdsAndFirstQuestion() async {
    isLoadingQuestion.value = true;
    try {
      contentIds.value = await repo.getAllContentIdsByTopic(topicId);
      if (contentIds.isNotEmpty) {
        userScores.value = List.filled(contentIds.length, 0);
        userFeedbacks.value = List.filled(contentIds.length, '');
        await loadWritingQuestion(contentIds[currentIndex]);
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

  Future<void> loadWritingQuestion(String contentId) async {
    isLoadingQuestion.value = true;
    try {
      question.value = await repo.getWritingDetail(contentId);
    } catch (e) {
      print("Error loading writing question: $e");
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
    loadWritingQuestion(contentIds[currentIndex]);
    userAnswer = "";
    textEditingController.clear();
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

  Future<void> checkAnswer(String answer) async {
    if (answer.trim().isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập câu trả lời!",
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

    const apiKey = "AIzaSyC2JfnsERoEvyBmGBnEs7oDKhc2Saml3K0";
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey');
    final level = levelName.toUpperCase();

    String prompt;
    if (level == 'BEGINNER') {
      prompt = '''
Bạn là giáo viên tiếng Anh. Hãy kiểm tra xem học sinh có điền đúng động từ vào chỗ trống hay không.

Câu hỏi: ${question.value?.body_text ?? ''}

Đáp án của học sinh: "$answer"

Yêu cầu:
- So sánh chính xác (không sai chính tả, sai dạng).
- Chỉ trả về đúng nếu hoàn toàn chính xác.

Trả về JSON (CHỈ JSON, không thêm text):
{
  "score": 10 hoặc 0,
  "comment": "<nhận xét ngắn bằng tiếng Việt>"
}

Luật:
- Nếu đúng: "Bạn làm rất tốt! Động từ được chia đúng vì [giải thích thì pháp ngắn gọn]."
- Nếu sai: "Sai rồi. Đáp án đúng là: [đáp án đúng]. Vì [giải thích ngắn]. Hãy học lại thì [tên thì]."
''';
    } else {
      prompt = '''
Bạn là giáo viên tiếng Anh chuyên nghiệp. Chấm bài viết theo 4 tiêu chí:

Câu hỏi: ${question.value?.body_text ?? ''}

Bài làm: """$answer"""

Tiêu chí:
1. Ngữ pháp (Grammar)
2. Từ vựng (Vocabulary)
3. Độ chính xác (Accuracy)
4. Tính mạch lạc (Coherence)

Trả về JSON (CHỈ JSON):
{
  "score": <điểm 0-10, số nguyên>,
  "comment": "<nhận xét ngắn gọn bằng tiếng Việt: điểm mạnh, điểm yếu, lỗi cụ thể, cách cải thiện>"
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
        "temperature": level == 'BEGINNER' ? 0.2 : 0.7,
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

          int finalScore;
          if (level == 'BEGINNER') {
            finalScore = (rawScore >= 10) ? 10 : 0;
          } else {
            finalScore = rawScore.clamp(0, 10);
          }

          score.value = finalScore;
          comment.value = result['comment'] ?? "Không có nhận xét";

          userScores[currentIndex] = finalScore;
          userFeedbacks[currentIndex] = result['comment'] ?? "";
          hasAnsweredCurrent.value = true;

          final color = finalScore >= 8
              ? Colors.green.shade100
              : finalScore >= 5
              ? Colors.orange.shade100
              : Colors.red.shade100;

          Get.snackbar(
            "Hoàn thành",
            "Điểm: $finalScore/10",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: color,
            duration: const Duration(seconds: 3),
          );
        } catch (e) {
          print("JSON parse error: $e");
          score.value = level == 'BEGINNER' ? 0 : 5;
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
      print("Error checking writing answer: $e");
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

  Future<void> submitResults() async {
    // KIỂM TRA hasSubmitted TRƯỚC
    if (isSubmitting.value || hasSubmitted.value) return;

    bool hasUnanswered = false;
    for (int i = 0; i < contentIds.length; i++) {
      if (userScores[i] == 0 && userFeedbacks[i].isEmpty) {
        hasUnanswered = true;
        break;
      }
    }

    if (hasUnanswered) {
      Get.snackbar(
        "Cảnh báo",
        "Bạn chưa trả lời hết các câu hỏi!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final total = contentIds.length;
      final level = levelName.toUpperCase();
      double finalScore;

      if (level == 'BEGINNER') {
        final correct = userScores.where((s) => s == 10).length;
        finalScore = (correct / total) * 10;
      } else {
        final sum = userScores.reduce((a, b) => a + b);
        finalScore = sum / total;
      }

      finalScore = double.parse(finalScore.toStringAsFixed(1));

      final combinedFeedback = userFeedbacks
          .asMap()
          .entries
          .where((e) => e.value.isNotEmpty)
          .map((e) => "Câu ${e.key + 1}: ${e.value}")
          .join("\n\n");

      final request = WritingSubmitRequest(
        topic_id: topicId,
        score: finalScore,
        feedback: combinedFeedback.isEmpty ? "Không có nhận xét." : combinedFeedback,
      );

      print("Submitting result: ${request.toJson()}");

      await repo.receiveResult(request);

      // ĐÁnh DẤU ĐÃ SUBMIT THÀNH CÔNG
      hasSubmitted.value = true;

      Get.snackbar(
        "Thành công",
        "Đã lưu kết quả! Điểm tổng kết của bạn là: $finalScore/10",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        duration: const Duration(seconds: 3),
      );

      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (e) {
      print("Error submitting results: $e");
      Get.snackbar(
        "Lỗi",
        "Không thể gửi kết quả: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}