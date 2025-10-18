import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/text_styles.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_page.dart';
import '../../../models/vocabulary/saved_word/saved_word_model.dart';
import 'saved_word_controller.dart';

class SavedWordPage extends StatelessWidget {
  const SavedWordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedWordController());

    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      backgroundColor: BgColors.main,
      appBar: BaseAppBar(title: "Danh sách từ đã lưu"),
      body: Obx(() {
        if (controller.words.isEmpty) {
          return const Center(
            child: Text("Chưa có từ nào được lưu"),
          );
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
      BuildContext context, SavedWordModel word, int index, SavedWordController controller) {
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
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${word.en} ",
                    style: TextStyles.mediumBold.copyWith(color: TextColors.main),
                  ),
                  TextSpan(
                    text: "${word.type} ",
                    style: TextStyles.medium.copyWith(color: Colors.black87),
                  ),
                  TextSpan(
                    text: word.vi,
                    style: TextStyles.medium.copyWith(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
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
