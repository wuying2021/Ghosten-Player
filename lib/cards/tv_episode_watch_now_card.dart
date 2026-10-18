import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import '../menus/episode.dart';
import '../utils/utils.dart';
import 'media_card.dart';

class EpisodeWatchNowCard extends MediaCard<TVEpisode> {
  const EpisodeWatchNowCard({super.key, required super.item, super.size, super.onTap});

  @override
  Widget build(BuildContext context) {
    final num progress = (item.lastPlayedPosition != null && item.duration != null && item.duration!.inSeconds != 0
        ? (item.lastPlayedPosition!.inSeconds / item.duration!.inSeconds * 100).round()
        : 0.0);
    return ImageCard(
      src: item.poster,
      width: size?.width,
      height: size?.height,
      title: Text('S${item.season} E${item.episode} - ${item.displayTitle()}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.seriesTitle != null) Text(item.seriesTitle!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (item.lastPlayedTime != null)
                Text(AppLocalizations.of(context)!.timeAgo(item.lastPlayedTime!.fromNow().fromNowFormat(context)))
              else
                const Spacer(),
              if (progress > 0) Text('$progress%'),
            ],
          ),
        ],
      ),
      floating: progress > 0
          ? Positioned(
              bottom: 6,
              left: 6,
              right: 6,
              child: LinearProgressIndicator(
                value: progress / 100,
                color: Theme.of(context).colorScheme.onSurface,
                backgroundColor: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(2),
                minHeight: 3,
              ),
            )
          : null,
      onTap: onTap ?? () => toMediaPlayer(context, .episode, item.id),
      onLongPress: () => context.showContextMenu(EpisodeMenu(item).buildSettingItems(context)),
    );
  }
}
