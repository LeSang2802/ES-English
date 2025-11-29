// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:es_english/models/test/test_response_model.dart';
// import '../../../cores/constants/colors.dart';
// import '../../../cores/constants/text_styles.dart';
// import '../test_repository.dart';
//
// class TestDetailController extends GetxController {
//   final TestRepository repo = TestRepository();
//
//   var isLoading = false.obs;
//   var questions = <TestQuestionItem>[].obs;
//   var currentQuestionIndex = 0.obs;
//   var userAnswers = <String, String>{}.obs; // bankQuestionId -> chosenLabel
//   var timeRemaining = 0.obs; // giây
//   Timer? _timer;
//
//   late final String testId;
//   late final String testTitle;
//   late final int durationMinutes;
//   String attemptId = '';
//
//   var correctCount = 0.obs;
//   var wrongCount = 0.obs;
//   var currentScore = 0.obs;
//
//   // Map lưu kết quả từng câu (bankQuestionId -> isCorrect)
//   var answerResults = <String, bool>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final arg = Get.arguments;
//     testId = arg['test_id'] ?? '';
//     testTitle = arg['test_title'] ?? '';
//     durationMinutes = arg['duration_minutes'] ?? 30;
//     timeRemaining.value = durationMinutes * 60;
//     loadTestDetail();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
//
//   Future<void> loadTestDetail() async {
//     isLoading.value = true;
//     try {
//       // Lấy nội dung bài thi
//       final response = await repo.getTestQuestions(testId);
//       questions.value = response.items ?? [];
//
//       // Bắt đầu bài thi (lấy attempt_id)
//       attemptId = await repo.startTest(testId);
//
//       // Bắt đầu đếm ngược
//       _startTimer();
//     } catch (e) {
//       print('Error load test detail: $e');
//       Get.snackbar('Lỗi', 'Không thể tải nội dung bài thi');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (timeRemaining.value > 0) {
//         timeRemaining.value--;
//       } else {
//         _timer?.cancel();
//         // Hết giờ -> tự động submit
//         submitTest();
//       }
//     });
//   }
//
//   String get formattedTime {
//     final minutes = timeRemaining.value ~/ 60;
//     final seconds = timeRemaining.value % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   void selectAnswer(String bankQuestionId, String label) {
//     final oldAnswer = userAnswers[bankQuestionId];
//     userAnswers[bankQuestionId] = label;
//
//     // Nếu đã trả lời trước đó → trừ điểm cũ trước khi cộng mới
//     if (oldAnswer != null && answerResults.containsKey(bankQuestionId)) {
//       final wasCorrect = answerResults[bankQuestionId]!;
//       if (wasCorrect) {
//         correctCount--;
//         currentScore--;
//       } else {
//         wrongCount--;
//       }
//     }
//
//     // Gửi ngay lên server để biết đúng/sai
//     _sendSingleAnswer(bankQuestionId, label);
//   }
//
//   Future<void> _sendSingleAnswer(String bankQuestionId, String label) async {
//     try {
//       final response = await repo.answerMulti(attemptId, [
//         UserAnswer(bankQuestionId: bankQuestionId, chosenOptionLabel: label)
//       ]);
//
//       if (response.answers != null && response.answers!.isNotEmpty) {
//         final result = response.answers!.first;
//         final isCorrect = result.isCorrect ?? false;
//
//         answerResults[bankQuestionId] = isCorrect;
//
//         // Cập nhật realtime
//         if (isCorrect) {
//           correctCount++;
//           currentScore += (result.score ?? 1);
//         } else {
//           wrongCount++;
//         }
//       }
//     } catch (e) {
//       // Không làm gì nếu lỗi mạng nhẹ
//       print("Error sending answer: $e");
//     }
//   }
//
//   String? getSelectedAnswer(String bankQuestionId) {
//     return userAnswers[bankQuestionId];
//   }
//
//   void nextQuestion() {
//     if (currentQuestionIndex.value < questions.length - 1) {
//       currentQuestionIndex.value++;
//     }
//   }
//
//   void previousQuestion() {
//     if (currentQuestionIndex.value > 0) {
//       currentQuestionIndex.value--;
//     }
//   }
//
//   void goToQuestion(int index) {
//     currentQuestionIndex.value = index;
//     Get.back(); // Đóng popup
//   }
//
//   int get answeredCount => userAnswers.length;
//   int get totalQuestions => questions.length;
//   int get unansweredCount => totalQuestions - answeredCount;
//
//   bool isQuestionAnswered(int index) {
//     if (index >= questions.length) return false;
//     final questionId = questions[index].question?.id;
//     return questionId != null && userAnswers.containsKey(questionId);
//   }
//
//   Future<void> submitTest() async {
//     _timer?.cancel();
//
//     try {
//       // Gửi tất cả đáp án còn lại (nếu có câu chưa gửi)
//       final unsent = userAnswers.entries
//           .where((e) => !answerResults.containsKey(e.key))
//           .map((e) => UserAnswer(bankQuestionId: e.key, chosenOptionLabel: e.value))
//           .toList();
//
//       if (unsent.isNotEmpty) {
//         await repo.answerMulti(attemptId, unsent);
//       }
//
//       // Nộp bài + lấy kết quả chính thức
//       final result = await repo.submitTest(attemptId);
//
//       // Hiển thị popup kết quả đẹp
//       _showResultDialog(result);
//
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể nộp bài. Vui lòng thử lại.');
//     }
//   }
//
//   void _showResultDialog(SubmitTestResponse result) {
//     final correct = result.correct ?? 0;
//     final wrong = result.wrong ?? 0;
//     final total = result.totalQuestions ?? questions.length;
//     final percentage = total > 0 ? (correct / total) * 100 : 0;
//
//     String advice;
//     if (percentage <= 30) {
//       advice = "Cố lên nhé! Bạn cần ôn luyện thêm nhiều hơn!";
//     } else if (percentage <= 60) {
//       advice = "Tốt! Bạn đã nắm được cơ bản. Tiếp tục phát huy!";
//     } else if (percentage <= 80) {
//       advice = "Rất tốt! Bạn đã làm bài khá chắc chắn!";
//     } else {
//       advice = "Xuất sắc! Bạn đã hoàn thành bài thi một cách tuyệt vời!";
//     }
//
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.celebration, size: 80, color: AppColors.primary),
//               const SizedBox(height: 16),
//               Text('Hoàn thành bài thi!', style: TextStyles.largeBold.copyWith(fontSize: 24)),
//               const SizedBox(height: 20),
//
//               Text('${result.score ?? 0}/$total điểm',
//                   style: TextStyles.largeBold.copyWith(fontSize: 48, color: AppColors.primary)),
//               Text('${percentage.toStringAsFixed(0)}%',
//                   style: TextStyles.largeBold.copyWith(fontSize: 32)),
//
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Column(children: [Text('Đúng', style: TextStyles.medium), Text('$correct', style: TextStyles.largeBold.copyWith(color: Colors.green, fontSize: 28))]),
//                   Column(children: [Text('Sai', style: TextStyles.medium), Text('$wrong', style: TextStyles.largeBold.copyWith(color: Colors.red, fontSize: 28))]),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
//                 child: Text(advice, textAlign: TextAlign.center, style: TextStyles.mediumBold.copyWith(color: AppColors.primary)),
//               ),
//
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   Get.back(); // đóng dialog
//                   Get.back(); // về danh sách đề thi
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16)),
//                 child: Text('Quay lại', style: TextStyle(fontSize: 18, color: Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//     );
//   }
//
//   void showQuestionList() {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Danh sách câu hỏi',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: List.generate(
//                   questions.length,
//                       (index) => _buildQuestionNumberButton(index),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () => Get.back(),
//                 child: const Text('Đóng'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuestionNumberButton(int index) {
//     final isAnswered = isQuestionAnswered(index);
//     final isCurrent = currentQuestionIndex.value == index;
//
//     return InkWell(
//       onTap: () => goToQuestion(index),
//       child: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: isCurrent
//               ? Colors.blue
//               : isAnswered
//               ? Colors.blue.shade100
//               : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             '${index + 1}',
//             style: TextStyle(
//               color: isCurrent || isAnswered ? Colors.blue.shade900 : Colors.black,
//               fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }











import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      advice = "Cố lên nhé! Bạn cần ôn luyện thêm nhiều hơn!";
    } else if (percentage <= 60) {
      advice = "Tốt! Bạn đã nắm được cơ bản. Tiếp tục phát huy!";
    } else if (percentage <= 80) {
      advice = "Rất tốt! Bạn đã làm bài khá chắc chắn!";
    } else {
      advice = "Xuất sắc! Bạn đã hoàn thành bài thi một cách tuyệt vời!";
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(Icons.celebration, size: 80, color: AppColors.primary),
              Image.asset(
                'assets/images/congra.png',
                height: 80,
              ),
              const SizedBox(height: 16),
              Text('Hoàn thành bài thi!', style: TextStyles.largeBold.copyWith(fontSize: 24)),
              const SizedBox(height: 20),

              Text('${result.score ?? 0}/$total điểm',
                  style: TextStyles.largeBold.copyWith(fontSize: 48, color: AppColors.primary)),
              // Text('${percentage.toStringAsFixed(0)}%',
              //     style: TextStyles.largeBold.copyWith(fontSize: 32)),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text('Đúng', style: TextStyles.medium),
                    Text('$correct', style: TextStyles.largeBold.copyWith(color: Colors.green, fontSize: 28))
                  ]),
                  Column(children: [
                    Text('Sai', style: TextStyles.medium),
                    Text('$wrong', style: TextStyles.largeBold.copyWith(color: Colors.red, fontSize: 28))
                  ]),
                ],
              ),

              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Text(
                    advice,
                    textAlign: TextAlign.center,
                    style: TextStyles.mediumBold.copyWith(color: AppColors.primary)
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // đóng dialog
                  Get.back(); // về danh sách đề thi
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16)
                ),
                child: Text('Quay lại', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
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
                'Danh sách câu hỏi',
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
                child: const Text('Đóng'),
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

