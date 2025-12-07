import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';
import '../../../models/skill/writing/content_item_writing_model.dart';
import '../../../models/skill/writing/writing_submit_request_model.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/text_styles.dart';
import 'writing_repository.dart';

class WritingController extends GetxController {
  final WritingRepository repo = WritingRepository();

  var isLoadingQuestion = false.obs;
  var isCheckingAnswer = false.obs;
  var isSubmitting = false.obs;

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

    const apiKey = "yourAPIKey";
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=$apiKey');
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

          // Get.snackbar(
          //   "Hoàn thành",
          //   "Điểm: $finalScore/10 - Đã lưu kết quả!",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: color,
          //   duration: const Duration(seconds: 3),
          // );
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

  Future<void> _submitSingleResult(int scoreValue, String feedback) async {
    try {
      final currentContentId = contentIds[currentIndex];

      final request = WritingSubmitRequest(
        topic_id: topicId,
        content_item_id: currentContentId,
        score: scoreValue.toDouble(),
        feedback: feedback.isEmpty ? "Không có nhận xét." : feedback,
      );

      print("Submitting single result: ${request.toJson()}");

      await repo.receiveResult(request);

      print("Single result submitted successfully for content: $currentContentId");
    } catch (e) {
      print("Error submitting single result: $e");
    }
  }

  // Tính toán thống kê
  int get totalQuestions => contentIds.length;
  int get totalScore => userScores.fold(0, (sum, score) => sum + score);
  int get maxPossibleScore => totalQuestions * 10;
  double get percentage => maxPossibleScore > 0 ? (totalScore / maxPossibleScore) * 100 : 0;

  // Đếm số câu đúng (điểm = 10) và sai (điểm = 0)
  int get correctCount => userScores.where((s) => s == 10).length;
  int get wrongCount => userScores.where((s) => s == 0).length;

  // Hiển thị dialog kết quả
  void _showResultDialog() {
    final level = levelName.toUpperCase();
    final totalScoreValue = totalScore;
    final maxScore = maxPossibleScore;
    final percentageValue = percentage;

    String advice;
    if (percentageValue <= 30) {
      advice = 'percentage_30'.tr;
    } else if (percentageValue <= 60) {
      advice ='percentage_60'.tr;
    } else if (percentageValue <= 80) {
      advice = 'percentage_80'.tr;
    } else {
      advice = 'percentage_writing'.tr;
    }

    // Tạo confetti controller
    final confettiController = ConfettiController(duration: const Duration(seconds: 3));
    confettiController.play();

    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          confettiController.dispose();
          return true;
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hình ảnh chúc mừng với pháo hoa
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/congra.png',
                      height: 80,
                    ),
                    ConfettiWidget(
                      confettiController: confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      emissionFrequency: 0.05,
                      numberOfParticles: 30,
                      gravity: 0.3,
                      shouldLoop: false,
                      maxBlastForce: 15,
                      minBlastForce: 8,
                      colors: const [
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                        Colors.purple,
                        Colors.orange,
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'theme_complete'.tr,
                  style: TextStyles.largeBold.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 20),

                // Hiển thị điểm theo level
                if (level == 'BEGINNER' && totalQuestions > 1) ...[
                  Text(
                    '$totalScoreValue/$maxScore ${'score'.tr}',
                    style: TextStyles.largeBold.copyWith(
                      fontSize: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ] else ...[
                  Text(
                    '$totalScoreValue/10 ${'score'.tr}',
                    style: TextStyles.largeBold.copyWith(
                      fontSize: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Thống kê đúng/sai cho BEGINNER nhiều câu
                if (level == 'BEGINNER' && totalQuestions > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('correct'.tr, style: TextStyles.medium),
                          Text(
                            '$correctCount',
                            style: TextStyles.largeBold.copyWith(
                              color: Colors.green,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('wrong'.tr, style: TextStyles.medium),
                          Text(
                            '$wrongCount',
                            style: TextStyles.largeBold.copyWith(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                if (level == 'BEGINNER' && totalQuestions > 1)
                  const SizedBox(height: 20),

                // Lời khuyên
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    advice,
                    textAlign: TextAlign.center,
                    style: TextStyles.mediumBold.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Nút quay lại
                ElevatedButton(
                  onPressed: () {
                    confettiController.dispose();
                    Get.back(); // đóng dialog
                    Get.back(); // về màn trước
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'come_back'.tr,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hàm kết thúc topic - hiển thị dialog
  Future<void> finishTopic() async {
    _showResultDialog();
  }
}