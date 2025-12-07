import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/widgets/base_app_bar.dart';
import 'package:es_english/cores/widgets/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class McqResultPage extends StatelessWidget {
  const McqResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final int totalCorrect = args['totalCorrect'] ?? 0;
    final int totalQuestions = args['totalQuestions'] ?? 0;
    final List resultList = args['resultList'] ?? [];

    final int score = totalCorrect * 10;
    final int maxScore = totalQuestions * 10;

    final percent = totalQuestions == 0
        ? 0.0
        : ((totalCorrect / totalQuestions) * 100).clamp(0, 100);

    return BasePage(
      isNestedScroll: false,
      isLoading: false.obs,
      backgroundColor: BgColors.main,
      // appBar: BaseAppBar(
      //   title: "Kết quả",
      //   showBackButton: true,
      // ),
      appBar: BaseAppBar(
        title:'result'.tr,
        showBackButton: false,
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
            Get.back();
          },
        ),
      ),

      isPaddingDefault: false,
      body: Padding(
        padding: EdgeInsets.all(MarginDimens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(MarginDimens.large),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "${'result'.tr}: $totalCorrect/$totalQuestions",
                    "${'result'.tr}: $score/$maxScore ${'score'.tr}",
                    style: TextStyles.mediumBold,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: const Offset(0, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      "${percent.toStringAsFixed(0)}%",
                      style: TextStyles.mediumBold
                          .copyWith(color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MarginDimens.extra),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(MarginDimens.normal),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'list_questions_answers'.tr,
                      style: TextStyles.mediumBold.copyWith(color: BgColors.appBar),
                    ),
                    SizedBox(height: MarginDimens.home),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: resultList.length,
                        separatorBuilder: (_, __) => Divider(
                          color: Colors.grey.shade300,
                          height: 10,
                        ),
                        itemBuilder: (context, index) {
                          final e = resultList[index];
                          final chosen = e['chosen'] ?? '';
                          final correct = e['correct'] ?? '';
                          final isCorrect = e['is_correct'] == true;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark,
                                    ),
                                    children: [
                                      TextSpan(text: "${'sentence'.tr} ${index + 1}: "),
                                      TextSpan(
                                        text: chosen, // chỉ phần đáp án
                                        style: TextStyle(
                                          color: isCorrect ? Colors.green : Colors.redAccent,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: MarginDimens.listening),
                              Flexible(
                                child: Text(
                                  "${'correct_answer'.tr}: $correct",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: MarginDimens.extra),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'back_to_home_page'.tr,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: MarginDimens.listening),
            GestureDetector(
              onTap: () => Get.offAllNamed('/skill'),
              child: Text(
                'practice_other_skills'.tr,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
