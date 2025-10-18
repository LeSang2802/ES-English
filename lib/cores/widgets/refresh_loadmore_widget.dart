import 'package:es_english/cores/widgets/loadmore_widget.dart';
import 'package:flutter/material.dart';

/// Widget kết hợp RefreshIndicator + LoadMoreWidget
/// Dùng khi cần cả kéo để refresh và scroll load thêm
class RefreshLoadMoreWidget<T> extends StatelessWidget {
  const RefreshLoadMoreWidget({
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
    this.separatorBuilder,
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
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Màu icon loading refresh
  final Color? refreshColor;

  /// Màu nền refresh indicator
  final Color? refreshBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: refreshColor ?? Theme.of(context).primaryColor,
      backgroundColor:
      refreshBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      onRefresh: onRefresh,
      child: LoadMoreWidget<T>(
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
        separatorBuilder: separatorBuilder,
      ),
    );
  }
}
