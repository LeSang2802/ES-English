import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// BasePage — khung chuẩn cho mọi màn hình trong dự án.
/// Đã tích hợp:
/// - AppBar tuỳ chọn
/// - BottomNavigationBar
/// - Drawer / EndDrawer
/// - Loading overlay (dùng RxBool)
/// - Pull-to-refresh
/// - Ẩn bàn phím khi chạm ra ngoài
/// - Padding / margin chuẩn
class BasePage extends StatelessWidget {
  /// trạng thái loading (Obx lắng nghe)
  final RxBool isLoading;

  /// tuỳ chọn loading riêng (ví dụ progress upload)
  final RxBool? isLoadingProgress;

  /// body chính của trang
  final Widget body;

  /// app bar tuỳ chỉnh (nếu null có thể tự build riêng)
  final PreferredSizeWidget? appBar;

  /// navigation dưới
  final Widget? bottomNavigationBar;

  /// bottom sheet
  final Widget? bottomSheet;

  /// drawer trái/phải
  final Widget? drawer;
  final Widget? endDrawer;

  /// background toàn màn
  final Color? backgroundColor;
  final Widget? bg;

  /// padding mặc định
  final bool isPaddingDefault;

  /// ẩn bàn phím khi chạm ra ngoài
  final bool hideKeyboardOnTouchOutside;

  /// cho phép scroll body
  final bool isNestedScroll;

  /// callback refresh
  final Future<void> Function()? onRefresh;

  /// widget loading tuỳ biến
  final Widget? loadingWidget;

  /// 🔹 FAB cho các trang có action ở giữa (ví dụ: nút Search)
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BasePage({
    super.key,
    required this.isLoading,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.bg,
    this.isPaddingDefault = true,
    this.hideKeyboardOnTouchOutside = true,
    this.isNestedScroll = true,
    this.onRefresh,
    this.isLoadingProgress,
    this.loadingWidget,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboardOnTouchOutside
          ? () => FocusScope.of(context).unfocus()
          : null,
      child: Stack(
        children: [
          Scaffold(
            appBar: appBar,
            drawer: drawer,
            endDrawer: endDrawer,
            bottomNavigationBar: bottomNavigationBar,
            bottomSheet: bottomSheet,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                if (bg != null) Positioned.fill(child: bg!),
                Column(
                  children: [
                    Expanded(
                      child: onRefresh == null
                          ? _buildBodyWithPadding()
                          : RefreshIndicator(
                        onRefresh: onRefresh!,
                        child: _buildBodyWithPadding(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // overlay loading
          Obx(
                () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: (isLoadingProgress?.value == true || isLoading.value)
                  ? (loadingWidget ??
                  const Center(
                    child: CircularProgressIndicator(),
                  ))
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyWithPadding() {
    final padding = isPaddingDefault
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : EdgeInsets.zero;

    final child = Padding(
      padding: padding,
      child: body,
    );

    // tránh lỗi scroll 0 height khi body là ListView
    return isNestedScroll
        ? SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: child,
    )
        : child;
  }
}
