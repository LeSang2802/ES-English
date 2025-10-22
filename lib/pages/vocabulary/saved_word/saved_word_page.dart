import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/text_styles.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_page.dart';
import '../../../models/vocabulary/saved_word/saved_word_model.dart';
import 'saved_word_controller.dart';

class SavedWordPage extends GetView<SavedWordController> {
  const SavedWordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      backgroundColor: BgColors.main,
      appBar: BaseAppBar(title: 'list_saved_word'.tr),
      body: Obx(() {
        if (controller.words.isEmpty) {
          return Center(child: Text('no_data'.tr));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.words.length,
          itemBuilder: (context, index) {
            final word = controller.words[index];
            return _buildWordCard(context, word, index + 1, controller);
          },
        );
      }),
    );
  }

  Widget _buildWordCard(
      BuildContext context,
      SavedWordModel word,
      int index,
      SavedWordController controller,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$index.",
            style: TextStyles.mediumBold.copyWith(color: TextColors.main),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.word ?? '',
                  style: TextStyles.mediumBold.copyWith(
                    color: TextColors.main,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${word.part_of_speech != null ? '(${word.part_of_speech}) ' : ''}${word.meaning_vi ?? ''}",
                  style: TextStyles.medium.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.toggleSave(word),
            icon: Icon(
              word.isSaved ? Icons.star : Icons.star_border,
              color: word.isSaved ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
