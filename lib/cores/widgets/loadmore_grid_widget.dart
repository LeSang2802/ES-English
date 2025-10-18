import 'package:flutter/material.dart';

/// Widget lưới load-more tái sử dụng (2xN)
/// - Hiển thị danh sách dạng grid
/// - Gọi [onLoadMore] khi cuộn tới cuối
/// - Có trạng thái loading ở cuối danh sách
/// - Hiển thị empty state khi không có dữ liệu
class LoadMoreGridWidget<T> extends StatefulWidget {
  const LoadMoreGridWidget({
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
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.childAspectRatio = 1.2,
  });

  /// Dữ liệu hiển thị
  final List<T> items;

  /// Hàm build mỗi item
  final Widget Function(BuildContext context, int index, T item) itemBuilder;

  /// Gọi khi tap vào item
  final void Function(int index, T item)? onTapItem;

  /// Gọi khi cuộn đến cuối danh sách
  final VoidCallback? onLoadMore;

  /// Cờ đang loading thêm
  final bool isLoadingMore;

  /// Text hiển thị khi không có dữ liệu
  final String emptyText;

  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;

  /// Cấu hình grid
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  @override
  State<LoadMoreGridWidget<T>> createState() => _LoadMoreGridWidgetState<T>();
}

class _LoadMoreGridWidgetState<T> extends State<LoadMoreGridWidget<T>> {
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
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            widget.emptyText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return GridView.builder(
      controller: _controller,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
