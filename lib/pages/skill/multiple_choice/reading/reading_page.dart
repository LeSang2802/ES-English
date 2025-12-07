import 'package:flutter/material.dart';
import 'package:es_english/pages/skill/multiple_choice/shared/mcq_page.dart';
import 'package:es_english/pages/skill/multiple_choice/reading/reading_controller.dart';
import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:get/get.dart';

class ReadingPage extends McqPage<ReadingController> {
  const ReadingPage({super.key});

  @override
  Widget buildContent(BuildContext context, ReadingController controller) {
    final item = controller.currentData.value?.item;

    return Padding(
      padding: EdgeInsets.all(MarginDimens.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "📘 ${item?.title ?? ''}",
          //   style: TextStyles.mediumBold.copyWith(color: AppColors.textDark),
          // ),
          SizedBox(height: MarginDimens.reading),
          _buildProgress(controller),
          SizedBox(height: MarginDimens.large),
          if (item?.media_image_url != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(item!.media_image_url!),
            ),
          if (item?.media_image_url != null) SizedBox(height: MarginDimens.large),
          Text(
            item?.body_text ?? '',
            style: TextStyles.normal.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(ReadingController controller) {
    if (controller.contentList.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${'question'.tr} ${controller.currentContentIndex.value + 1} / ${controller.contentList.length}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          Text(
            '${((controller.currentContentIndex.value + 1) / controller.contentList.length * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}