import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:es_english/models/test/test_response_model.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/text_styles.dart';
import '../test_repository.dart';

class TestDetailController extends GetxController {
  final TestRepository repo = TestRepository();

  var isLoading = false.obs;
  var questions = <TestQuestionItem>[].obs;
  var currentQuestionIndex = 0.obs;
  var userAnswers = <String, String>{}.obs; // bankQuestionId -> chosenLabel
  var timeRemaining = 0.obs; // giây
  Timer? _timer;

  late final String testId;
  late final String testTitle;
  late final int durationMinutes;
  String attemptId = '';

  var correctCount = 0.obs;
  var wrongCount = 0.obs;
  var currentScore = 0.obs;

  // Map lưu kết quả từng câu (bankQuestionId -> isCorrect)
  var answerResults = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    testId = arg['test_id'] ?? '';
    testTitle = arg['test_title'] ?? '';
    durationMinutes = arg['duration_minutes'] ?? 30;
    timeRemaining.value = durationMinutes * 60;
    loadTestDetail();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> loadTestDetail() async {
    isLoading.value = true;
    try {
      // Lấy nội dung bài thi
      final response = await repo.getTestQuestions(testId);
      questions.value = response.items ?? [];

      // Bắt đầu bài thi (lấy attempt_id)
      attemptId = await repo.startTest(testId);

      print('✅ Started test with attempt_id: $attemptId');

      // Bắt đầu đếm ngược
      _startTimer();
    } catch (e) {
      print('❌ Error load test detail: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải nội dung bài thi: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        _timer?.cancel();
        // Hết giờ -> tự động submit
        submitTest();
      }
    });
  }

  String get formattedTime {
    final minutes = timeRemaining.value ~/ 60;
    final seconds = timeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void selectAnswer(String bankQuestionId, String label) {
    userAnswers[bankQuestionId] = label;
    print('📝 Selected answer: Q[$bankQuestionId] = $label');
  }

  String? getSelectedAnswer(String bankQuestionId) {
    return userAnswers[bankQuestionId];
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void goToQuestion(int index) {
    currentQuestionIndex.value = index;
    Get.back(); // Đóng popup
  }

  int get answeredCount => userAnswers.length;
  int get totalQuestions => questions.length;
  int get unansweredCount => totalQuestions - answeredCount;

  bool isQuestionAnswered(int index) {
    if (index >= questions.length) return false;
    final questionId = questions[index].question?.id;
    return questionId != null && userAnswers.containsKey(questionId);
  }

  Future<void> submitTest() async {
    _timer?.cancel();

    if (attemptId.isEmpty) {
      Get.snackbar('Lỗi', 'Không tìm thấy phiên làm bài');
      return;
    }

    try {
      // Hiển thị loading
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Gửi TẤT CẢ đáp án lên server
      if (userAnswers.isNotEmpty) {
        final allAnswers = userAnswers.entries
            .map((e) => UserAnswer(
          bankQuestionId: e.key,
          chosenOptionLabel: e.value,
        ))
            .toList();

        print('📤 Sending ${allAnswers.length} answers to server...');

        final answerResponse = await repo.answerMulti(attemptId, allAnswers);

        print('✅ Answer response: ${answerResponse.savedCount} saved');

        // Cập nhật kết quả từng câu
        if (answerResponse.answers != null) {
          for (var result in answerResponse.answers!) {
            final isCorrect = result.isCorrect ?? false;
            answerResults[result.bankQuestionId ?? ''] = isCorrect;

            if (isCorrect) {
              correctCount.value++;
              currentScore.value += (result.score ?? 1);
            } else {
              wrongCount.value++;
            }
          }
        }
      }

      // Nộp bài + lấy kết quả chính thức
      print('📤 Submitting test...');
      final result = await repo.submitTest(attemptId);
      print('✅ Submit result: ${result.correct}/${result.totalQuestions}');

      // Đóng loading
      Get.back();

      // Hiển thị popup kết quả
      _showResultDialog(result);

    } catch (e) {
      // Đóng loading nếu có
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('❌ Error submit test: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể nộp bài: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showResultDialog(SubmitTestResponse result) {
    final correct = result.correct ?? 0;
    final wrong = result.wrong ?? 0;
    final total = result.totalQuestions ?? questions.length;
    final percentage = total > 0 ? (correct / total) * 100 : 0;

    String advice;
    if (percentage <= 30) {
      advice = 'percentage_30'.tr;
    } else if (percentage <= 60) {
      advice = 'percentage_60'.tr;
    } else if (percentage <= 80) {
      advice = 'percentage_80'.tr;
    } else {
      advice = 'percentage'.tr;
    }
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
                  'Complete_the_test'.tr,
                  style: TextStyles.largeBold.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 20),

                Text(
                  '${result.score ?? 0}/$total ${'score'.tr}',
                  style: TextStyles.largeBold.copyWith(
                    fontSize: 48,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('correct'.tr, style: TextStyles.medium),
                        Text(
                          '$correct',
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
                          '$wrong',
                          style: TextStyles.largeBold.copyWith(
                            color: Colors.red,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
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
                ElevatedButton(
                  onPressed: () {
                    confettiController.dispose();
                    Get.back(); // đóng dialog
                    Get.back(); // về danh sách đề thi
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
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

  void showQuestionList() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'list_of_questions'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  questions.length,
                      (index) => _buildQuestionNumberButton(index),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('close'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionNumberButton(int index) {
    final isAnswered = isQuestionAnswered(index);
    final isCurrent = currentQuestionIndex.value == index;

    return InkWell(
      onTap: () => goToQuestion(index),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isCurrent
              ? Colors.blue
              : isAnswered
              ? Colors.blue.shade100
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: isCurrent || isAnswered ? Colors.blue.shade900 : Colors.black,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

