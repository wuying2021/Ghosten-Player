import 'package:flutter/material.dart';

import 'headered_content.dart';
import 'wrap_list_theme.dart';

class SliverWrapList extends StatelessWidget {
  const SliverWrapList({super.key, required this.header, required this.itemCount, required this.itemBuilder});

  final Widget header;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final WrapListThemeData theme = WrapListTheme.of(context);
    return itemCount > 0
        ? SliverHeaderedContent(
            header: header,
            headerPadding: theme.headerPadding ?? .zero,
            sliver: SliverPadding(
              padding: theme.padding ?? .zero,
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: theme.spacing ?? 0,
                  runSpacing: theme.runSpacing ?? 0,
                  children: List.generate(itemCount, (index) => itemBuilder(context, index)),
                ),
              ),
            ),
          )
        : const SliverToBoxAdapter();
  }
}
