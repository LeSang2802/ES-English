import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// BaseAppBar — AppBar tuỳ biến chuẩn cho dự án ES English
/// - Nền mặc định AppColors.primary
/// - Nút quay lại mặc định Get.back()
/// - Có thể truyền actionWidget (nút bên phải)
/// - Có thể custom leadingWidget nếu muốn
/// - Tự động dịch text qua .tr
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // key đa ngôn ngữ hoặc text
  final Color? bgColor; // màu nền (nếu null -> AppColors.primary)
  final Widget? actionWidget; // nút bên phải (vd: search, save)
  final Widget? leadingWidget; // custom nút trái (nếu null -> back)
  final bool showBackButton;

  const BaseAppBar({
    super.key,
    required this.title,
    this.bgColor,
    this.actionWidget,
    this.leadingWidget,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final background = bgColor ?? BgColors.appBar;

    return Container(
      color: background,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: SizedBox(
        height: OtherDimens.appBarHeight,
        child: Row(
          children: [
            // Leading — mặc định nút back
            // leadingWidget ??
            //     IconButton(
            //       icon: Icon(Icons.arrow_back,
            //           color: IconColors.icArrowBack, size: IconDimens.normal),
            //       onPressed: () => Get.back(),
            //     ),

            // ✅ Logic hiển thị nút Back hoặc không
            if (leadingWidget != null)
              leadingWidget!
            else if (showBackButton)
              IconButton(
                icon: Icon(Icons.arrow_back,
                    color: IconColors.icArrowBack, size: IconDimens.normal),
                onPressed: () => Get.back(),
              )
            else
              const SizedBox(width: 40), // Giữ layout cân đối nếu ko có back

            // Title — dịch tự động qua .tr
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: TextStyles.mediumBold.copyWith(
                  color: TextColors.appBar, // bạn có thể đặt TextColors.white nếu muốn luôn trắng
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            // Action (nếu null thì giữ khoảng trống để cân đối)
            actionWidget ?? SizedBox(width: IconDimens.normal),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        OtherDimens.appBarHeight +
            MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .padding
                .top,
      );
}
