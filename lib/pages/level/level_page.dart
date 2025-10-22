import 'package:es_english/pages/level/level_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cores/constants/colors.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/widgets/base_app_bar.dart';
import '../../cores/widgets/base_page.dart';
import '../../cores/widgets/refresh_loadmore_widget.dart';
import '../../models/level/level_response_model.dart';

class LevelPage extends GetView<LevelController> {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(title: "${controller.skillName}"),
      body: Obx(() {
        final items = controller.levels.toList();
        if (items.isEmpty) {
          return Center(child: Text('no_level'.tr));
        }
        return RefreshLoadMoreWidget<LevelResponseModel>(
          items: items,
          onRefresh: controller.refreshData,
          isLoadingMore: false,
          onTapItem: (_, level) => controller.onSelectLevel(level),
          itemBuilder: (context, index, level) =>
              _buildLevelCard(context, level),
        );
      }),
    );
  }

  Widget _buildLevelCard(BuildContext context, LevelResponseModel level) {
    String description;
    switch (level.name?.toLowerCase()) {
      case 'beginner':
        description = 'for_beginner'.tr;
        break;
      case 'intermediate':
        description = 'for_intermediate'.tr;
        break;
      case 'advanced':
        description = 'for_advanced'.tr;
        break;
      default:
        description = '';
    }

    return Container(
      margin: EdgeInsets.only(top: MarginDimens.normal),
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
            child: const Icon(Icons.auto_stories_rounded,
                color: AppColors.primary, size: 28),
          ),
          SizedBox(width: MarginDimens.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(level.name ?? '-', style: TextStyles.mediumBold),
                SizedBox(height: MarginDimens.small),
                Text(
                  description,
                  style: TextStyles.medium.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
