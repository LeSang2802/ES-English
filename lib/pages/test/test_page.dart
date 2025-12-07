import 'package:es_english/pages/test/test_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cores/constants/colors.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/widgets/base_app_bar.dart';
import '../../cores/widgets/base_page.dart';
import '../../cores/widgets/refresh_loadmore_widget.dart';
import '../../models/test/test_response_model.dart';

class TestPage extends GetView<TestController> {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(title: 'test'.tr),
      body: Obx(() {
        final items = controller.tests.toList();
        if (items.isEmpty) {
          return Center(child: Text('choose_exam'.tr));
        }
        return RefreshLoadMoreWidget<TestResponseModel>(
          items: items,
          onRefresh: controller.refreshData,
          isLoadingMore: false,
          onTapItem: (_, test) => controller.onSelectTest(test),
          itemBuilder: (context, index, test) =>
              _buildTestCard(context, index, test),
        );
      }),
    );
  }

  Widget _buildTestCard(BuildContext context, int index, TestResponseModel test) {
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
            child: Center(
              child: Text(
                '${'exam'.tr} ${index + 1}:',
                style: TextStyles.mediumBold.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: MarginDimens.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(test.title ?? '-', style: TextStyles.mediumBold),
                SizedBox(height: MarginDimens.small),
                Text(
                  '${'time'.tr}: ${test.durationMinutes ?? 0} ${'min'.tr}',
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