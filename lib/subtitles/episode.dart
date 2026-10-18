import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/utils.dart';

class EpisodeSubtitle extends StatelessWidget {
  const EpisodeSubtitle({super.key, required this.item, this.style, this.iconSize});

  final TVEpisode item;
  final TextStyle? style;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      overflow: .ellipsis,
      style: style,
      TextSpan(
        children: [
          // TextSpan(text: item.seriesTitle),
          // const TextSpan(text: '  ·  '),
          TextSpan(text: AppLocalizations.of(context)!.seasonNumber(item.season)),
          const TextSpan(text: ' · '),
          TextSpan(text: AppLocalizations.of(context)!.episodeNumber(item.episode)),
          if (item.airDate != null) ...[
            const TextSpan(text: '  ·  '),
            WidgetSpan(
              alignment: .middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.calendar_month_rounded, size: iconSize, color: style?.color),
              ),
            ),
            TextSpan(text: item.airDate?.format() ?? AppLocalizations.of(context)!.tagUnknown),
          ],
          if (item.duration != null) ...[
            const TextSpan(text: '  ·  '),
            WidgetSpan(
              alignment: .middle,
              child: Icon(Icons.access_time_rounded, size: iconSize, color: style?.color),
            ),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(text: item.duration!.toDisplay()),
          ],
        ],
      ),
    );
  }
}
