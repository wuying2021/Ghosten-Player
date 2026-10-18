import 'package:api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide ListTile;

import '../../l10n/app_localizations.dart';
import '../../utils/tmdb_uri.dart';
import '../adaptive/adaptive.dart';
import '../cards/cards.dart';
import '../extensions/extensions.dart';
import '../utils/utils.dart';
import 'abstract.dart';

class SeriesMenu extends Menu {
  const SeriesMenu(this.item);

  final TVSeries item;

  @override
  List<Widget> build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return [
      if (theme.functions.menuShortcuts) ...[
        SeriesCard(item: item, size: theme.seriesCardTheme.minSize, direction: .horizontal),
        const Divider(),
        buildPlayAction(context, item.id, .series),
        buildCastAction(context, item.id, .series),
        const Divider(),
        buildWatchedAction(context, item, MediaType.series),
        buildFavoriteAction(context, item, MediaType.series),
        const Divider(),
      ],
      ListTile(
        title: Text(AppLocalizations.of(context)!.buttonSyncLibrary),
        leading: const Icon(Icons.video_library_outlined),
        onTap: () async {
          final AsyncSnapshot<void>? res = await showNotification(context, Api.tvSeriesSyncById(item.id));
          if (res?.error is DioException) {
            if ((res!.error! as DioException).response?.statusCode == 404) {
              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
            }
          } else if (context.mounted) {
            // setState(() {});
            // await _updatePlaylist(context);
          }
        },
      ),
      ListTile(
        enabled: false,
        title: Text(AppLocalizations.of(context)!.buttonSaveMediaInfoToDriver),
        leading: const Icon(Icons.save_outlined),
        // onTap: () => showNotification(context, Api.tvSeriesRenameById(item.id)),
      ),
      const Divider(),
      buildScrapeAction(context, item),
      const Divider(),
      buildSkipFromStartAction(context, item, MediaType.series, item.skipIntro),
      buildSkipFromEndAction(context, item, MediaType.series, item.skipEnding),
      const Divider(),
      buildEditMetadataAction(context, item, .series),
      if (item.scraper.id != null) ...[
        buildHomeAction(context, ImdbUri(MediaType.series, item.scraper.id!).toUri()),
        const Divider(),
      ],
      buildDeleteAction(context, () => Api.tvSeriesDeleteById(item.id)),
    ];
  }
}
