import 'package:es_english/pages/vocabulary/vocabulary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/dimens.dart';
import '../../../cores/constants/text_styles.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_page.dart';
import '../../../models/topic/topic_response_model.dart';

class VocabularyPage extends GetView<VocabularyController> {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      backgroundColor: BgColors.main,
      appBar: BaseAppBar(title: 'vocabulary'.tr,
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offNamed('/home'),
        ),
      ),
      body: Obx(() {
        final topics = controller.topics.toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSavedButton(controller),
            const SizedBox(height: 20),
            Text('choose_topic'.tr, style: TextStyles.mediumBold),
            const SizedBox(height: 12),
            if (topics.isEmpty)
              Center(child: Text('no_data'.tr)),
            ...topics.map(
                  (topic) => _buildTopicCard(context, topic, controller),
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
            const Icon(Icons.bookmark, color: Colors.black87),
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

  /// 🔹 Card từng chủ đề flashcard
  Widget _buildTopicCard(
      BuildContext context, TopicResponseModel topic, VocabularyController controller) {
    return GestureDetector(
      onTap: () => controller.onSelectTopic(topic),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_stories_rounded,
                  color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title ?? '-',
                    style: TextStyles.mediumBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.description ?? '',
                    style: TextStyles.small.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
