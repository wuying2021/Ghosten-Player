import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../l10n/app_localizations.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key, this.trimLines = 2, required this.text, this.poster});

  final String? text;
  final String? poster;
  final int trimLines;

  @override
  Widget build(BuildContext context) {
    final Widget overview = text != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isOverflow = _hasTextOverflow(
                  text!,
                  Theme.of(context).textTheme.bodyMedium!,
                  maxWidth: constraints.maxWidth,
                  maxLines: trimLines,
                );
                return isOverflow
                    ? InkWell(
                        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          text!,
                          maxLines: trimLines,
                          overflow: .ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            showDragHandle: true,
                            constraints: const BoxConstraints.expand(),
                            builder: (context) => Scrollbar(
                              child: SingleChildScrollView(
                                padding: const .symmetric(horizontal: 12),
                                child: SafeArea(child: SelectableText(text!)),
                              ),
                            ),
                          );
                        },
                      )
                    : Text(text!, style: Theme.of(context).textTheme.bodyMedium);
              },
            ),
          )
        : Text(AppLocalizations.of(context)!.noOverview);
    final p = AsyncImage(
      poster ?? '',
      width: 120,
      height: 180,
      fit: BoxFit.contain,
      radius: const BorderRadius.all(Radius.circular(8)),
      viewable: true,
    );

    return switch ((poster, text)) {
      (null, null) => const SliverToBoxAdapter(),
      (_, null) => SliverToBoxAdapter(child: p),
      (null, _) => SliverToBoxAdapter(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: overview),
      ),
      (_, _) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        sliver: SliverToBoxAdapter(
          child: Row(
            spacing: 16,
            children: [
              p,
              Expanded(child: overview),
            ],
          ),
        ),
      ),
    };
  }

  bool _hasTextOverflow(String text, TextStyle style, {double maxWidth = double.infinity, int? maxLines}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}
