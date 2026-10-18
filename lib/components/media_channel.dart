import 'package:flutter/material.dart';

import 'components.dart ';

class MediaChannel<T> extends StatelessWidget {
  const MediaChannel({
    super.key,
    required this.label,
    required this.builder,
    required this.future,
    this.loadingBuilder,
    this.onTap,
    this.cardStyle,
  });

  final Future<List<T>> future;
  final String label;
  final MediaCardThemeData? cardStyle;
  final Widget Function(BuildContext, T, Size) builder;
  final Widget Function(BuildContext, Size)? loadingBuilder;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilderSliverHandler(
      future: future,
      errorBuilder: (context, snapshot) => SliverToBoxAdapter(
        child: SizedBox(height: 200, child: ErrorMessage(error: snapshot.error)),
      ),
      loadingBuilder: loadingBuilder != null
          ? (context, snapshot) => SliverToBoxAdapter(
              child: IgnorePointer(
                child: HorizontalList(
                  header: Align(
                    alignment: .centerLeft,
                    child: PlaceholderRRect(
                      height: 24,
                      width: label.length * 24,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  cardStyle: cardStyle,
                  itemCount: 10,
                  itemBuilder: (context, index, size) => loadingBuilder!(context, size),
                ),
              ),
            )
          : null,
      builder: (context, snapshot) => SliverHorizontalList(
        header: Text(label),
        cardStyle: cardStyle,
        itemCount: snapshot.requireData.length,
        onTap: onTap,
        itemBuilder: (context, index, size) => builder(context, snapshot.requireData[index], size),
      ),
    );
  }
}
