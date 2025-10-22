import 'package:es_english/pages/topic/topic_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cores/constants/colors.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/widgets/base_app_bar.dart';
import '../../cores/widgets/base_page.dart';
import '../../cores/widgets/refresh_loadmore_widget.dart';
import '../../models/topic/topic_response_model.dart';

class TopicPage extends GetView<TopicController> {
  const TopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(
        title:
        "${controller.skillName} - ${controller.levelName}",
      ),
      body: Obx(() {
        final items = controller.topics.toList();
        if (items.isEmpty) {
          return Center(child: Text('no_topic'.tr));
        }
        return RefreshLoadMoreWidget<TopicResponseModel>(
          items: items,
          onRefresh: controller.refreshData,
          isLoadingMore: false,
          onTapItem: (_, topic) => controller.onSelectTopic(topic),
          itemBuilder: (context, index, topic) =>
              _buildTopicCard(context, topic),
        );
      }),
    );
  }

  Widget _buildTopicCard(BuildContext context, TopicResponseModel topic) {
    return Container(
      margin: EdgeInsets.only(
        top: MarginDimens.normal,
        left: MarginDimens.large,
        right: MarginDimens.large,
      ),
      padding: EdgeInsets.all(MarginDimens.large),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RadiusDimens.normal),
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
            width: IconDimens.iconOnCard,
            height: IconDimens.iconOnCard,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(RadiusDimens.normal),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          SizedBox(width: MarginDimens.large),
          Expanded(
            child: Text(
              topic.title ?? '-',
              style: TextStyles.mediumBold,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
