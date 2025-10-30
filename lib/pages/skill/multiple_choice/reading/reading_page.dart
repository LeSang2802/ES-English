import 'package:flutter/material.dart';
import 'package:es_english/pages/skill/multiple_choice/shared/mcq_page.dart';
import 'package:es_english/pages/skill/multiple_choice/reading/reading_controller.dart';
import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/constants/dimens.dart';

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
          Text(
            "📘 ${item?.title ?? ''}",
            style: TextStyles.mediumBold.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: MarginDimens.reading),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: controller.totalProgress,
              color: AppColors.primary,
              backgroundColor: Colors.grey.shade300,
              minHeight: 8,
            ),
          ),
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
}
