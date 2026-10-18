import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../components/components.dart ';
import '../l10n/app_localizations.dart';
import '../menus/season.dart';
import '../utils/utils.dart';
import 'media_card.dart';

class SeasonCard extends MediaCard<TVSeason> {
  const SeasonCard({super.key, required super.item, super.size, super.direction});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      item.themeColor,
      builder: (context) => ImageCard(
        direction: direction,
        src: item.poster,
        width: size?.width,
        height: size?.height,
        title: Text(
          item.title ?? AppLocalizations.of(context)!.seasonNumber(item.season),
          textAlign: switch (direction) {
            Axis.horizontal => null,
            _ => TextAlign.center,
          },
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.episodeCount(item.episodeCount ?? '未知'),
          textAlign: switch (direction) {
            Axis.horizontal => null,
            _ => TextAlign.center,
          },
        ),
        onTap: () => context.pushNamed(.detailSeason, arguments: {'id': item.id, 'data': item}),
        onLongPress: () => context.showContextMenu(SeasonMenu(item).buildSettingItems(context)),
      ),
    );
  }
}
