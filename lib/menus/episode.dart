import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../utils/tmdb_uri.dart';
import '../cards/cards.dart';
import '../extensions/extensions.dart';
import 'abstract.dart';

class EpisodeMenu extends Menu {
  const EpisodeMenu(this.item);

  final TVEpisode item;

  @override
  List<Widget> build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return [
      if (theme.functions.menuShortcuts) ...[
        EpisodeCard(
          item: item,
          size: Size(
            theme.episodeCardTheme.minWidth!,
            theme.episodeCardTheme.minWidth! / theme.episodeCardTheme.aspectRatio!,
          ),
        ),
        const Divider(),
        buildPlayAction(context, item.id, .episode),
        buildCastAction(context, item.id, .episode),
        const Divider(),
        buildWatchedAction(context, item, MediaType.episode),
        buildFavoriteAction(context, item, MediaType.episode),
        const Divider(),
      ],
      buildSkipFromStartAction(context, item, MediaType.episode, item.skipIntro),
      buildSkipFromEndAction(context, item, MediaType.episode, item.skipEnding),
      const Divider(),
      buildEditMetadataAction(context, item, .episode),
      if (item.fileId != null) buildSubtitleAction(context, item.fileId!),
      if (item.fileId != null) buildDownloadAction(context, item.downloaded),
      if (item.scraper.id != null)
        buildHomeAction(
          context,
          ImdbUri(MediaType.episode, item.scraper.id!, season: item.season, episode: item.episode).toUri(),
        ),
      const Divider(),
      if (item.fileId != null) buildDeleteAction(context, () => Api.tvEpisodeDeleteById(item.id)),
    ];
  }
}
