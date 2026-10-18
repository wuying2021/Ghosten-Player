import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'aspect_ratio_grid_theme.dart';
import 'loading.dart';
import 'media_card_theme.dart';

class AspectRatioSliverGrid<T> extends StatefulWidget {
  const AspectRatioSliverGrid({super.key, required this.itemBuilder, required this.onQuery, this.cardStyle});

  final Widget Function(BuildContext, T, Size) itemBuilder;
  final Future<PageData<T>> Function(int) onQuery;
  final MediaCardThemeData? cardStyle;

  @override
  State<AspectRatioSliverGrid<T>> createState() => _AspectRatioSliverGridState<T>();
}

class _AspectRatioSliverGridState<T> extends State<AspectRatioSliverGrid<T>> {
  final GlobalKey _sliverKey = GlobalKey();
  Size _size = .zero;
  SliverGridDelegate _gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1);
  PagingState<int, T> _state = PagingState();
  int? _count;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderObject? renderObject = _sliverKey.currentContext?.findRenderObject();
      if (renderObject is RenderSliver) {
        final SliverConstraints constraints = renderObject.constraints;
        setState(() {
          final double width = constraints.crossAxisExtent;
          final double itemMinWidth = widget.cardStyle?.minWidth ?? 100;
          final double aspectRatio = widget.cardStyle?.aspectRatio ?? 1;
          final double heightExtent = widget.cardStyle?.heightExtent ?? 0;
          assert(width > itemMinWidth);
          final AspectRatioGridThemeData theme = AspectRatioGridTheme.of(context);
          final double crossAxisSpacing = theme.crossAxisSpacing ?? 0;
          final double mainAxisSpacing = theme.mainAxisSpacing ?? 0;
          final int crossAxisCount = ((width + crossAxisSpacing) / (itemMinWidth + crossAxisSpacing)).floor();
          final double fixedWidth = (width - crossAxisSpacing * (crossAxisCount - 1)) / crossAxisCount;
          final double fixedHeight = fixedWidth / aspectRatio;
          _size = Size(fixedWidth, fixedHeight);
          _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: _size.height + heightExtent,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_count == 0 || _size.isEmpty) {
      return SliverToBoxAdapter(key: _sliverKey);
    }
    return PagedSliverGrid(
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: (context, item, _) => widget.itemBuilder(context, item, _size),
        noMoreItemsIndicatorBuilder: (context) => const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            spacing: 16,
            children: [
              FractionallySizedBox(widthFactor: 0.5, child: Divider()),
              Text(
                'THE END',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        firstPageProgressIndicatorBuilder: (context) => const Loading(),
        newPageProgressIndicatorBuilder: (context) =>
            const Padding(padding: EdgeInsets.only(top: 16), child: Loading()),
      ),
      showNewPageProgressIndicatorAsGridChild: false,
      showNoMoreItemsIndicatorAsGridChild: false,
      gridDelegate: _gridDelegate,
      fetchNextPage: _fetchNextPage,
      state: _state,
    );
  }

  Future<void> _fetchNextPage() async {
    if (_state.isLoading) {
      return;
    }

    await Future.value();

    setState(() {
      _state = _state.copyWith(isLoading: true, error: null);
    });

    try {
      final int newKey = (_state.keys?.last ?? -1) + 1;
      final PageData<T> data = await widget.onQuery(newKey);
      final bool hasNextPage = data.offset + data.limit < data.count;
      if (!mounted) {
        return;
      }
      setState(() {
        _state = _state.copyWith(
          pages: [...?_state.pages, data.data],
          keys: [...?_state.keys, newKey],
          hasNextPage: hasNextPage,
          isLoading: false,
        );
        _count = data.count;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _state = _state.copyWith(error: error, isLoading: false);
      });
    }
  }
}
