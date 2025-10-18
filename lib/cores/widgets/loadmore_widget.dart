import 'package:flutter/material.dart';

/// Widget danh sách load-more tái sử dụng
/// - Hiển thị danh sách items
/// - Gọi [onLoadMore] khi kéo tới cuối
/// - Có trạng thái loading cuối danh sách
/// - Hiển thị empty state khi không có dữ liệu
class LoadMoreWidget<T> extends StatefulWidget {
  const LoadMoreWidget({
    super.key,
    required this.items,
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
  });

  /// Danh sách dữ liệu
  final List<T> items;

  /// Hàm build từng item
  final Widget Function(BuildContext context, int index, T item) itemBuilder;

  /// Gọi khi tap vào item
  final void Function(int index, T item)? onTapItem;

  /// Gọi khi cuộn đến cuối danh sách
  final VoidCallback? onLoadMore;

  /// Đang loading thêm
  final bool isLoadingMore;

  /// Text hiển thị khi danh sách trống
  final String emptyText;

  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  @override
  State<LoadMoreWidget<T>> createState() => _LoadMoreWidgetState<T>();
}

class _LoadMoreWidgetState<T> extends State<LoadMoreWidget<T>> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (widget.onLoadMore == null || widget.isLoadingMore) return;
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 100) {
      widget.onLoadMore?.call();
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            widget.emptyText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _controller,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
      separatorBuilder: widget.separatorBuilder ??
              (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index < widget.items.length) {
          final item = widget.items[index];
          final tile = widget.itemBuilder(context, index, item);
          return widget.onTapItem == null
              ? tile
              : GestureDetector(
            onTap: () => widget.onTapItem?.call(index, item),
            child: tile,
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
