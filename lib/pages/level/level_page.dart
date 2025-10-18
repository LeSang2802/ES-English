import 'package:es_english/pages/level/level_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../cores/constants/colors.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/widgets/base_app_bar.dart';
import '../../cores/widgets/base_bottom_nav.dart';
import '../../cores/widgets/base_page.dart';
import '../../cores/widgets/refresh_loadmore_widget.dart';
import '../../models/level/level_model.dart';

class LevelPage extends StatelessWidget {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LevelController());

    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(title: "Chọn cấp độ"),
      bottomNavigationBar: BaseBottomNav(
        currentIndex: 1,
        onTap: (index) {},
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bottom,
        elevation: 3,
        shape: const CircleBorder(),
        onPressed: () => Get.toNamed('/search'),
        child: const Icon(Icons.search, color: AppColors.primary, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() => RefreshLoadMoreWidget<Level>(
        items: controller.levels,
        onRefresh: controller.refreshData,
        isLoadingMore: controller.isLoadingMore.value,
        onTapItem: (_, level) => controller.onSelectLevel(level),
        itemBuilder: (context, index, level) => _buildLevelCard(context, level),
      )),
    );
  }

  Widget _buildLevelCard(BuildContext context, Level level) {
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
            child: Icon(Icons.auto_stories_rounded,
                color: AppColors.primary, size: 28),
          ),
          SizedBox(width: MarginDimens.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(level.title, style: TextStyles.mediumBold),
                SizedBox(height: MarginDimens.small),
                Text(
                  level.description,
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
