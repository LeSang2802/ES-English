import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/widgets/base_app_bar.dart';
import 'package:es_english/cores/widgets/base_page.dart';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'flash_card_controller.dart';
import '../../../models/vocabulary/flash_card/flash_card_model.dart';

class FlashCardPage extends GetView<FlashCardController> {
  const FlashCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      backgroundColor: BgColors.main,
      appBar: BaseAppBar(title: controller.topicTitle,
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed('/vocabulary'),
        ),
      ),
      isPaddingDefault: false,
      body: Obx(() {
        if (controller.vocabularies.isEmpty) {
          return  Center(child: Text('no_data'.tr));
        }

        final vocabularies = controller.vocabularies;

        return Column(
          children: [
            SizedBox(height: MarginDimens.extra),

            Expanded(
              child: PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vocabularies.length,
                itemBuilder: (context, index) {
                  final word = vocabularies[index];
                  return Center(
                    child: FlashCard(
                      frontWidget: _buildBack(word),
                      backWidget: _buildFront(word, controller),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: MarginDimens.normal),

            //Hiển thị vị trí thẻ
            Obx(() => Text(
              "${controller.currentIndex.value + 1}/${vocabularies.length}",
              style: TextStyles.largeBold,
            )),

            SizedBox(height: MarginDimens.large),

            // Nút điều hướng trái - phải
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    controller.prevCard();
                    pageController.animateToPage(
                      controller.currentIndex.value,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      color: AppColors.primary, size: IconDimens.large),
                ),
               SizedBox(width: MarginDimens.flashcard),
                IconButton(
                  onPressed: () {
                    controller.nextCard();
                    pageController.animateToPage(
                      controller.currentIndex.value,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios,
                      color: AppColors.primary, size: IconDimens.large),
                ),
              ],
            ),

            SizedBox(height: MarginDimens.large),

            //Thanh tiến trình
            Obx(() => SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: LinearProgressIndicator(
                value: (controller.currentIndex.value + 1) /
                    vocabularies.length,
                backgroundColor: BgColors.avatar,
                valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )),
            SizedBox(height: MarginDimens.extra),
          ],
        );
      }),
    );
  }

  Widget _buildFront(FlashCardModel word, FlashCardController c) {
    return Container(
      decoration: BoxDecoration(
        color: BgColors.flashCard,
        borderRadius: BorderRadius.circular(RadiusDimens.normal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding:EdgeInsets.all(MarginDimens.large),
      child: Column(
        children: [
          // ⭐ Icon lưu
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                word.isSaved ? Icons.star : Icons.star_border,
                color: word.isSaved ? AppColors.primary : Colors.grey,
                size: 28,
              ),
              onPressed: () => c.toggleSave(word),
            ),
          ),

          const Spacer(),
          if (word.image_url != null && word.image_url!.isNotEmpty)
            Image.network(
              word.image_url!,
              height: 150,
              fit: BoxFit.contain,
            ),
          SizedBox(height: MarginDimens.large),
          Text(
            word.word ?? '',
            style: TextStyles.extraBold.copyWith(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          if (word.phonetic != null)
            Text(
              word.phonetic!,
              style: TextStyles.small.copyWith(color: Colors.grey[700]),
            ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded,
                size: 32, color: AppColors.primary),
            onPressed: () => c.playAudio(word.audio_url),
          ),
          const Spacer(),
        ],
      ),
    );
  }


  Widget _buildBack(FlashCardModel word) {
    return Container(
      decoration: BoxDecoration(
        color: BgColors.flashCard,
        borderRadius: BorderRadius.circular(RadiusDimens.normal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(MarginDimens.large),
      child: Center(
        child: Text(
          "${word.part_of_speech != null ? "(${word.part_of_speech}) " : ""}${word.meaning_vi ?? ""}",
          style: TextStyles.largeBold.copyWith(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
