import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/text_styles.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_page.dart';
import '../../../models/vocabulary/vocabulary_model.dart';
import 'vocabulary_controller.dart';

class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VocabularyController());

    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      backgroundColor: BgColors.main,
      appBar: BaseAppBar(title: 'vocabulary'.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSavedButton(controller),
            const SizedBox(height: 20),
            Text('choose_topic'.tr, style: TextStyles.mediumBold),
            const SizedBox(height: 12),
            ...controller.vocabularies.map(
                  (vocab) => _buildVocabularyCard(context, vocab, controller),
            ),
          ],
        );
      }),
    );
  }

  /// 🔹 Nút “Từ đã lưu”
  Widget _buildSavedButton(VocabularyController controller) {
    return GestureDetector(
      onTap: controller.goToSavedWords,
      child: Container(
        padding: const EdgeInsets.all(14),
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
          children: [
            const Icon(Icons.list_alt, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Text('saved_word'.tr, style: TextStyles.mediumBold),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// 🔹 Card từng chủ đề
  Widget _buildVocabularyCard(
      BuildContext context, Vocabulary vocab, VocabularyController controller) {
    final isSelected = controller.selectedId.value == vocab.id;

    return GestureDetector(
      // onTap: () => controller.select(vocab),
      onTap: () {
        controller.select(vocab);
        Get.toNamed('/flashCard');
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
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
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                image: vocab.imageUrl != null
                    ? DecorationImage(
                  image: AssetImage(vocab.imageUrl!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                vocab.name,
                style: TextStyles.mediumBold.copyWith(color: TextColors.main),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
