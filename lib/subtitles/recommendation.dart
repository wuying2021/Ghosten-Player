import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/utils.dart';

class RecommendationSubtitle extends StatelessWidget {
  const RecommendationSubtitle({super.key, required this.item, this.style, this.iconSize});

  final MediaRecommendation item;
  final TextStyle? style;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      overflow: .ellipsis,
      style: style,
      TextSpan(
        children: [
          WidgetSpan(
            alignment: .middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.calendar_month_rounded, size: iconSize, color: style?.color),
            ),
          ),
          TextSpan(text: item.airDate?.format() ?? AppLocalizations.of(context)!.tagUnknown),
          const TextSpan(text: '  ·  '),
          WidgetSpan(
            alignment: .middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: iconSize),
            ),
          ),
          TextSpan(text: item.voteAverage?.toStringAsFixed(1) ?? AppLocalizations.of(context)!.tagUnknown),
          const TextSpan(text: '  ·  '),
          TextSpan(text: AppLocalizations.of(context)!.seriesStatus(item.status.name)),
        ],
      ),
    );
  }
}
