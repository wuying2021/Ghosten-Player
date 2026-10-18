import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import '../menus/episode.dart';
import '../utils/utils.dart';
import 'media_card.dart';

class EpisodeCard extends MediaCard<TVEpisode> {
  const EpisodeCard({super.key, required super.item, super.size});

  @override
  Widget build(BuildContext context) {
    return ImageCard(
      direction: .horizontal,
      src: item.poster,
      width: size?.width,
      height: size?.height,
      floating: Positioned(
        right: 4,
        bottom: 4,
        child: BadgeTheme(
          data: BadgeTheme.of(context).copyWith(
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            textStyle: const TextStyle(fontSize: 10),
          ),
          child: IconTheme(
            data: IconTheme.of(context).copyWith(size: 10, color: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                if (item.watched) const Badge(label: Icon(Icons.check)),
                if (item.favorite) const Badge(label: Icon(Icons.favorite_rounded)),
                if (item.downloaded) const Badge(label: Icon(Icons.download_rounded)),
                if (item.duration != null && item.duration! > Duration.zero)
                  Badge(label: Text(item.duration!.toDisplay())),
              ],
            ),
          ),
        ),
      ),
      title: Text('${item.episode}. ${item.displayTitle()}'),
      subtitle: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(item.airDate?.format() ?? AppLocalizations.of(context)!.tagUnknown),
          Text(
            item.overview ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onLongPress: () => context.showContextMenu(EpisodeMenu(item).buildSettingItems(context)),
      onTap: () => context.pushNamed(.detailEpisode, arguments: {'id': item.id, 'data': item}),
    );
  }
}
