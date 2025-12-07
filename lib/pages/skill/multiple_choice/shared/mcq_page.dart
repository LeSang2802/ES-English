import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/widgets/base_page.dart';
import '../../../../cores/widgets/base_app_bar.dart';
import 'mcq_controller.dart';

//Base page hiển thị giao diện MCQ chung cho các kỹ năng (Reading, Listening,…)
abstract class McqPage<T extends McqController> extends GetView<T> {
  const McqPage({super.key});

  //Render phần nội dung chính (ví dụ bài đọc, hình, audio,…)
  Widget buildContent(BuildContext context, T controller);

  //Hook cho phép subclass override cách hiển thị danh sách đáp án
  Widget buildOptions(BuildContext context, T controller, dynamic question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final opt in question.options)
          _buildOption(controller, question.id as String, opt),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      appBar: BaseAppBar(
        title:(controller.contentType),
      ),
      body: Obx(() {
        final data = controller.currentData.value;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final qList = data.questions;
        final qIndex = controller.currentQuestionIndex.value;
        if (qList.isEmpty) return Center(child: Text('no_data'.tr));

        final q = qList[qIndex];
        final isLastContent =
            controller.currentContentIndex.value == controller.contentList.length - 1;
        final isLastQuestion = qIndex == qList.length - 1 && isLastContent;

        // Kiểm tra trạng thái câu hỏi hiện tại
        final selectedOption = controller.selectedOptions[q.id];
        final isChecked = controller.checkedQuestions[q.id] ?? false;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: SingleChildScrollView(
            key: ValueKey("${controller.currentContentIndex}_${qIndex}"),
            padding: EdgeInsets.only(bottom: MarginDimens.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === NỘI DUNG CHÍNH ===
                buildContent(context, controller),

                // === CÂU HỎI + ĐÁP ÁN ===
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MarginDimens.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.question_text ?? '-', style: TextStyles.mediumBold),
                      SizedBox(height: MarginDimens.listening),
                      buildOptions(context, controller, q),
                    ],
                  ),
                ),

                // === NÚT ĐIỀU HƯỚNG ===
                Padding(
                  padding: EdgeInsets.all(MarginDimens.large),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút KIỂM TRA
                      if (!isChecked)
                        ElevatedButton(
                          onPressed: selectedOption == null
                              ? null
                              : () => controller.checkAnswer(q.id as String),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(160, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('check'.tr,
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),

                      // Nút TIẾP TỤC hoặc NỘP BÀI
                      if (isChecked)
                        ElevatedButton(
                          onPressed: () {
                            if (isLastQuestion) {
                              // controller.submitAll();
                              controller.submitCurrentAttempt();
                            } else {
                              controller.nextQuestion();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(160, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isLastQuestion ? 'submit'.tr : 'continue'.tr,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  //HIỂN THỊ 1 ĐÁP ÁN MẶC ĐỊNH
  Widget _buildOption(T c, String questionId, dynamic option) {
    final selectedId = c.selectedOptions[questionId];
    final isSelected = selectedId == option.id;
    final isChecked = c.checkedQuestions[questionId] ?? false;
    final isCorrect = c.questionResults[questionId] == true;
    final correctId = c.getCorrectOptionId(questionId);

    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.white;
    Color textColor = Colors.black87;

    if (!isChecked) {
      // Trước khi kiểm tra: đáp án được chọn màu xanh nước biển
      if (isSelected) {
        borderColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
      }
    } else {
      // Sau khi kiểm tra: hiển thị đúng/sai
      if (isSelected && isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
      } else if (!isSelected && option.id == correctId && !isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.05);
        textColor = Colors.green;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton(
        // onPressed: isChecked
        //     ? null
        //     : () => c.onSelectOption(questionId, option.id as String),
        onPressed: isChecked
            ? null
            : () => c.onSelectOption(questionId, option.id.toString()), // Thêm .toString()
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.3),
          backgroundColor: bgColor,
          padding: EdgeInsets.all(MarginDimens.normal),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${option.label ?? ''}. ${option.option_text ?? ''}",
            style: TextStyle(color: textColor, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
