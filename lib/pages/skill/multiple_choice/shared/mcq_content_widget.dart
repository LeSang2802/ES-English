import 'package:flutter/material.dart';
import '../../../../cores/constants/colors.dart';
import '../../../../cores/constants/dimens.dart';
import '../../../../cores/constants/text_styles.dart';
import '../../../../models/skill/multiple_choice/content_item_model.dart';

/// Widget hiển thị nội dung chính của bài (đọc / nghe / hình ảnh)
class McqContentWidget extends StatelessWidget {
  final ContentItem? item;
  const McqContentWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox();

    return Padding(
      padding: EdgeInsets.all(MarginDimens.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📘 ${item?.title ?? ''}",
            style: TextStyles.mediumBold.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          if (item?.media_image_url != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(item!.media_image_url!),
            ),
          if (item?.media_image_url != null) const SizedBox(height: 12),
          if (item?.media_audio_url != null)
            Column(
              children: [
                const Icon(Icons.audiotrack, color: AppColors.primary, size: 32),
                Text("(Audio content)"),
                const SizedBox(height: 8),
              ],
            ),
          Text(item?.body_text ?? '',
              style: TextStyles.normal.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
