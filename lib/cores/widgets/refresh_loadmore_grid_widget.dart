import 'package:flutter/material.dart';
import 'loadmore_grid_widget.dart';

/// Widget kết hợp RefreshIndicator + LoadMoreGridWidget
/// - Dùng khi cần vừa kéo để refresh, vừa load thêm khi cuộn tới cuối
class RefreshLoadMoreGridWidget<T> extends StatelessWidget {
  const RefreshLoadMoreGridWidget({
    super.key,
    required this.items,
    required this.onRefresh,
    required this.itemBuilder,
    this.onTapItem,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.emptyText = 'Không có dữ liệu',
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.scrollController,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.childAspectRatio = 1.2,
    this.refreshColor,
    this.refreshBackgroundColor,
  });

  final List<T> items;
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final void Function(int index, T item)? onTapItem;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final String emptyText;

  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;

  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  final Color? refreshColor;
  final Color? refreshBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: refreshColor ?? Theme.of(context).primaryColor,
      backgroundColor:
      refreshBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      onRefresh: onRefresh,
      child: LoadMoreGridWidget<T>(
        items: items,
        itemBuilder: itemBuilder,
        onTapItem: onTapItem,
        onLoadMore: onLoadMore,
        isLoadingMore: isLoadingMore,
        emptyText: emptyText,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        scrollController: scrollController,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
    );
  }
}
