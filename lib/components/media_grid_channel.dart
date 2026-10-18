import 'package:api/api.dart';
import 'package:flutter/material.dart';

import 'aspect_ratio_grid.dart';
import 'headered_content.dart';
import 'media_card_theme.dart';

class MediaGridChannel<T> extends StatelessWidget {
  const MediaGridChannel({
    super.key,
    required this.label,
    required this.itemBuilder,
    required this.onQuery,
    this.contentPadding = .zero,
    this.headerPadding = .zero,
    this.cardStyle,
  });

  final String label;
  final Widget Function(BuildContext, T, Size) itemBuilder;
  final Future<PageData<T>> Function(int) onQuery;
  final MediaCardThemeData? cardStyle;
  final EdgeInsets contentPadding;
  final EdgeInsets headerPadding;

  @override
  Widget build(BuildContext context) {
    return SliverHeaderedContent(
      header: Text(label),
      headerPadding: headerPadding,
      sliver: SliverPadding(
        padding: contentPadding.add(const EdgeInsets.only(bottom: 32)),
        sliver: AspectRatioSliverGrid(
          itemBuilder: (context, item, size) => itemBuilder(context, item, size),
          cardStyle: cardStyle,
          onQuery: onQuery,
        ),
      ),
    );
  }
}
