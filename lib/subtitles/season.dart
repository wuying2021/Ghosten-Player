import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/utils.dart';

class SeasonSubtitle extends StatelessWidget {
  const SeasonSubtitle({super.key, required this.item, this.style, this.iconSize});

  final TVSeason item;
  final TextStyle? style;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      overflow: TextOverflow.ellipsis,
      style: style,
      TextSpan(
        children: [
          TextSpan(text: AppLocalizations.of(context)!.seasonNumber(item.season)),
          const TextSpan(text: '  ·  '),
          if (item.episodeCount != null) ...[
            if (item.episodes.isNotEmpty) TextSpan(text: item.episodes.length.toString()),
            if (item.episodes.isNotEmpty) const TextSpan(text: ' / '),
            TextSpan(text: AppLocalizations.of(context)!.episodeCount(item.episodeCount!)),
          ] else
            TextSpan(text: AppLocalizations.of(context)!.episodeCount(item.episodes.length)),
          const TextSpan(text: '  ·  '),
          if (item.airDate != null) ...[
            WidgetSpan(
              alignment: .middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.calendar_month_rounded, size: iconSize, color: style?.color),
              ),
            ),
            TextSpan(text: item.airDate?.format()),
          ],
        ],
      ),
    );
  }
}
