import 'dart:math';

import 'package:flutter/material.dart';

import 'headered_content.dart';
import 'horizontal_list_theme.dart';
import 'media_card_theme.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.header,
    this.onTap,
    this.cardStyle,
  });

  final int itemCount;
  final MediaCardThemeData? cardStyle;
  final Widget header;
  final Widget Function(BuildContext, int, Size) itemBuilder;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return const SizedBox();
    }
    final HorizontalListThemeData themeData = HorizontalListTheme.of(context);
    final double heightExtent = cardStyle?.heightExtent ?? 0;
    final EdgeInsets padding = themeData.padding ?? .zero;
    final EdgeInsets headerPadding = themeData.headerPadding ?? .zero;
    final double itemSpacing = themeData.itemSpacing ?? 0;
    final double itemMinWidth = cardStyle?.minWidth ?? 100;
    final double aspectRatio = cardStyle?.aspectRatio ?? 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth - (themeData.padding?.horizontal ?? 0);
        assert(width > itemMinWidth);
        final int crossAxisCount = ((width + itemSpacing) / (itemMinWidth + itemSpacing)).floor();
        final double fixedWidth = (width + itemSpacing) / crossAxisCount - itemSpacing;
        final double fixedHeight = fixedWidth / aspectRatio;
        return HeaderedContent(
          header: header,
          headerPadding: headerPadding,
          onTap: onTap,
          child: SizedBox(
            height: fixedHeight + heightExtent + padding.vertical,
            child: Scrollbar(
              child: ListView.builder(
                padding: padding,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => index.isEven
                    ? itemBuilder(context, index ~/ 2, Size(fixedWidth, fixedHeight))
                    : SizedBox(width: itemSpacing),
                itemCount: max(0, itemCount * 2 - 1),
                itemExtentBuilder: (index, _) => index.isOdd ? itemSpacing : fixedWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SliverHorizontalList extends StatefulWidget {
  const SliverHorizontalList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.header,
    this.onTap,
    this.cardStyle,
  });

  final int itemCount;
  final MediaCardThemeData? cardStyle;
  final Widget header;
  final Widget Function(BuildContext, int, Size) itemBuilder;
  final GestureTapCallback? onTap;

  @override
  State<SliverHorizontalList> createState() => _SliverHorizontalListState();
}

class _SliverHorizontalListState extends State<SliverHorizontalList> {
  Widget? _cachedChild;
  Size size = .zero;

  @override
  void didUpdateWidget(covariant SliverHorizontalList oldWidget) {
    _cachedChild = null;
    size = .zero;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return const SliverToBoxAdapter();
    }
    final HorizontalListThemeData themeData = HorizontalListTheme.of(context);
    final double heightExtent = widget.cardStyle?.heightExtent ?? 0;
    final EdgeInsets padding = themeData.padding ?? .zero;
    final EdgeInsets headerPadding = themeData.headerPadding ?? .zero;
    final double itemSpacing = themeData.itemSpacing ?? 0;
    final double itemMinWidth = widget.cardStyle?.minWidth ?? 100;
    final double aspectRatio = widget.cardStyle?.aspectRatio ?? 1;
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.crossAxisExtent - (themeData.padding?.horizontal ?? 0);
        assert(width > itemMinWidth);
        final int crossAxisCount = ((width + itemSpacing) / (itemMinWidth + itemSpacing)).floor();
        final double fixedWidth = (width + itemSpacing) / crossAxisCount - itemSpacing;
        final double fixedHeight = fixedWidth / aspectRatio;
        final fixedSize = Size(fixedWidth, fixedHeight);
        if (size != fixedSize) {
          size = fixedSize;
          final listView = ListView.builder(
            key: ValueKey(size),
            padding: padding,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                index.isEven ? widget.itemBuilder(context, index ~/ 2, size) : SizedBox(width: itemSpacing),
            itemCount: max(0, widget.itemCount * 2 - 1),
            itemExtentBuilder: (index, _) => index.isOdd ? itemSpacing : size.width,
          );
          _cachedChild = SliverHeaderedContent(
            header: widget.header,
            headerPadding: headerPadding,
            onTap: widget.onTap,
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: size.height + heightExtent + padding.vertical,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: Scrollbar(child: listView),
                ),
              ),
            ),
          );
        }
        if (_cachedChild != null) {
          return _cachedChild!;
        } else {
          return const SliverToBoxAdapter();
        }
      },
    );
  }
}
