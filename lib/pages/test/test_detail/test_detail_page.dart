import 'package:es_english/pages/test/test_detail/test_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/constants/dimens.dart';
import '../../../cores/constants/text_styles.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_page.dart';

class TestDetailPage extends GetView<TestDetailController> {
  const TestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(
        title: controller.testTitle,
        actionWidget: Row(                     // chỉ nhận 1 Widget
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Center(
                child: Text(
                  controller.formattedTime,
                  style: TextStyles.largeBold.copyWith(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            )),
            IconButton(
              icon: const Icon(Icons.list, color: Colors.white),
              onPressed: controller.showQuestionList,
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.questions.isEmpty) {
          return const Center(child: Text('Không có câu hỏi'));
        }

        final currentQuestion = controller.questions[controller.currentQuestionIndex.value];
        final question = currentQuestion.question;
        if (question == null) {
          return const Center(child: Text('Lỗi: Không tải được câu hỏi'));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(MarginDimens.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Câu hỏi
                    Text(
                      'Câu ${controller.currentQuestionIndex.value + 1}: ${question?.questionText ?? ''}',
                      style: TextStyles.largeBold,
                    ),
                    SizedBox(height: OtherDimens.appBarHeight),

                    // Chọn câu trả lời đúng:
                    Text(
                      'Chọn câu trả lời đúng:',
                      style: TextStyles.mediumBold,
                    ),
                    SizedBox(height: MarginDimens.large),

                    // Options
                    ...?question?.options?.map((option) {
                      final isSelected = controller.getSelectedAnswer(question?.id ?? '') == option.label;

                      return GestureDetector(
                        onTap: () => controller.selectAnswer(question?.id ?? '', option.label ?? ''),
                        child: Container(
                          margin: EdgeInsets.only(bottom: MarginDimens.normal),
                          padding: EdgeInsets.symmetric(
                            horizontal: MarginDimens.large,
                            vertical: MarginDimens.large,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(RadiusDimens.normal),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    option.label ?? '',
                                    style: TextStyles.mediumBold.copyWith(
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: MarginDimens.large),
                              Expanded(
                                child: Text(
                                  option.optionText ?? '',
                                  style: TextStyles.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Navigation buttons
            Container(
              padding: EdgeInsets.all(MarginDimens.large),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Previous button
                  Obx(() => IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: controller.currentQuestionIndex.value > 0
                        ? controller.previousQuestion
                        : null,
                  )),

                  const Spacer(),

                  // Submit button (hiển thị ở câu cuối)
                  Obx(() {
                    if (controller.currentQuestionIndex.value == controller.questions.length - 1) {
                      return ElevatedButton(
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Nộp bài'),
                              content: Text(
                                'Bạn đã trả lời ${controller.answeredCount}/${controller.totalQuestions} câu.\n'
                                    'Bạn có chắc muốn nộp bài?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.submitTest();
                                  },
                                  child: const Text('Nộp bài'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Nộp bài',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  const Spacer(),

                  // Next button
                  Obx(() => IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: controller.currentQuestionIndex.value < controller.questions.length - 1
                        ? controller.nextQuestion
                        : null,
                  )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}