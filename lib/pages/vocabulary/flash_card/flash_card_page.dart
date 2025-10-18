import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/widgets/base_app_bar.dart';
import 'package:es_english/cores/widgets/base_page.dart';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/vocabulary/flash_card/flash_card_model.dart';
import 'flash_card_controller.dart';

class FlashCardPage extends StatelessWidget {
  const FlashCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlashCardController());
    final pageController = PageController();

    return BasePage(
      isLoading: false.obs,
      isNestedScroll: false,
      backgroundColor: BgColors.main,
      appBar: BaseAppBar(title: 'Từ vựng'),
      isPaddingDefault: false,
      body: Obx(() {
        if (controller.vocabularies.isEmpty) {
          return Center(child: Text('no_data'.tr));
        }

        return Column(
          children: [
            const SizedBox(height: 20),

            // 🔹 Flashcard hiển thị từ vựng
            Expanded(
              child: PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.vocabularies.length,
                itemBuilder: (context, index) {
                  final word = controller.vocabularies[index];
                  return Center(
                    child: FlashCard(
                      frontWidget: _buildCardBack(word.vi, word.type),
                      backWidget: _buildCardFront(word, controller),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // 🔹 Hiển thị vị trí thẻ
            Obx(
              () => Text(
                "${controller.currentIndex.value + 1}/${controller.vocabularies.length}",
                style: TextStyles.largeBold,
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Nút điều hướng trái - phải
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
                const SizedBox(width: 40),
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

            const SizedBox(height: 16),

            // 🔹 Thanh tiến trình
            Obx(
              () => SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: LinearProgressIndicator(
                  value: (controller.currentIndex.value + 1) /
                      controller.vocabularies.length,
                  backgroundColor: BgColors.avatar,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _buildCardFront(FlashCardModel word, FlashCardController c) {
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
      padding: EdgeInsets.all(PaddingDimens.horizontalLarge),
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(
                  word.isSaved
                      ? Icons.star
                      : Icons.star_border,
                  color: word.isSaved ? AppColors.primary : Colors.grey,
                  size: 26,
                ),
                onPressed: () {
                  word.isSaved = !word.isSaved;
                  c.update();
                },
              ),
            ],
          ),
          Spacer(),
          if (word.imageUrl != null && word.imageUrl!.isNotEmpty)
            Image.asset(
              word.imageUrl!,
              height: 150,
              fit: BoxFit.contain,
            ),
          SizedBox(height: MarginDimens.flashcard),
          Text(
            word.en ?? '',
            style: TextStyles.extraBold.copyWith(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: Icon(Icons.volume_up_rounded,
                size: 32, color: AppColors.primary),
            onPressed: () {
              c.playAudio(word.audioUrl);
            },
          ),
          Spacer(),
        ],
      ),
    );
  }

  // 🟨 Mặt sau: nghĩa tiếng Việt + loại từ
  Widget _buildCardBack(String? wordVi, String? type) {
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
      padding: EdgeInsets.all(PaddingDimens.horizontalLarge),
      child: Center(
        child: Text(
          "${type != null && type.isNotEmpty ? "($type) " : ""}${wordVi ?? ""}",
          style: TextStyles.largeBold.copyWith(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


// import 'package:es_english/cores/constants/colors.dart';
// import 'package:es_english/cores/constants/dimens.dart';
// import 'package:es_english/cores/constants/text_styles.dart';
// import 'package:es_english/cores/widgets/base_app_bar.dart';
// import 'package:es_english/cores/widgets/base_page.dart';
// import 'package:flash_card/flash_card.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'flash_card_controller.dart';
//
// class FlashCardPage extends StatelessWidget {
//   const FlashCardPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(FlashCardController());
//     final pageController = PageController();
//
//     return BasePage(
//       isLoading: false.obs,
//       isNestedScroll: false,
//       backgroundColor: BgColors.main,
//       appBar: BaseAppBar(title: 'Từ vựng'),
//       isPaddingDefault: false,
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.vocabularies.isEmpty) {
//           return Center(child: Text('No Flashcards'));
//         }
//
//         return Column(
//           children: [
//             const SizedBox(height: 20),
//
//             // Flashcard hiển thị
//             Expanded(
//               child: PageView.builder(
//                 controller: pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: controller.vocabularies.length,
//                 itemBuilder: (context, index) {
//                   final word = controller.vocabularies[index];
//                   return Center(
//                     child: FlashCard(
//                       frontWidget: _buildFront(word, controller),
//                       backWidget: _buildBack(word),
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       height: MediaQuery.of(context).size.height * 0.5,
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             // Hiển thị vị trí
//             Obx(
//                   () => Text(
//                 "${controller.currentIndex.value + 1}/${controller.vocabularies.length}",
//                 style: TextStyles.largeBold,
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Điều hướng trái - phải
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     controller.prevCard();
//                     pageController.animateToPage(
//                       controller.currentIndex.value,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                   icon: Icon(Icons.arrow_back_ios,
//                       color: AppColors.primary, size: IconDimens.large),
//                 ),
//                 const SizedBox(width: 40),
//                 IconButton(
//                   onPressed: () {
//                     controller.nextCard();
//                     pageController.animateToPage(
//                       controller.currentIndex.value,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                   icon: Icon(Icons.arrow_forward_ios,
//                       color: AppColors.primary, size: IconDimens.large),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//
//             // Thanh tiến trình
//             Obx(
//                   () => SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.6,
//                 child: LinearProgressIndicator(
//                   value: (controller.currentIndex.value + 1) /
//                       controller.vocabularies.length,
//                   backgroundColor: BgColors.avatar,
//                   valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//           ],
//         );
//       }),
//     );
//   }
//
//   /// 🟦 Mặt trước: Word + Image + Loa
//   Widget _buildFront(word, FlashCardController c) {
//     return Container(
//       decoration: BoxDecoration(
//         color: BgColors.flashCard,
//         borderRadius: BorderRadius.circular(RadiusDimens.normal),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Spacer(),
//           if (word.imageUrl != null && word.imageUrl!.isNotEmpty)
//             Image.network(
//               word.imageUrl!,
//               height: 150,
//               fit: BoxFit.contain,
//             ),
//           const SizedBox(height: 16),
//           Text(
//             word.word,
//             style: TextStyles.extraBold.copyWith(fontSize: 26),
//             textAlign: TextAlign.center,
//           ),
//           IconButton(
//             icon: Icon(Icons.volume_up_rounded,
//                 size: 32, color: AppColors.primary),
//             onPressed: () => c.playAudio(word.audioUrl),
//           ),
//           Spacer(),
//         ],
//       ),
//     );
//   }
//
//   /// 🟨 Mặt sau: Phonetic + MeaningVi
//   Widget _buildBack(word) {
//     return Container(
//       decoration: BoxDecoration(
//         color: BgColors.flashCard,
//         borderRadius: BorderRadius.circular(RadiusDimens.normal),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (word.phonetic != null)
//               Text(
//                 word.phonetic!,
//                 style: TextStyles.largeBold.copyWith(fontSize: 22),
//               ),
//             const SizedBox(height: 10),
//             Text(
//               word.meaningVi ?? "",
//               style: TextStyles.largeBold.copyWith(fontSize: 22),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
