import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;

import '../../l10n/app_localizations.dart';
import '../adaptive/adaptive.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../viewers/cast_adaptor.dart';

abstract class Menu {
  const Menu();

  List<Widget> build(BuildContext context);

  List<Widget> buildSettingItems(BuildContext context) {
    return build(context)
        .map(
          (item) => switch (item) {
            final ListTile item => ListTile(
              title: item.title,
              subtitle: item.subtitle,
              leading: item.leading,
              selected: item.selected,
              enabled: item.enabled,
              onTap: item.onTap,
            ),
            final Divider item => item,
            _ => ListTile(enabled: false, title: AbsorbPointer(child: item)),
          },
        )
        .toList();
  }

  ListTile buildPlayAction(BuildContext context, dynamic id, MediaType type) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buttonPlay),
      leading: const Icon(Icons.play_arrow_rounded),
      onTap: () => toMediaPlayer(context, type, id),
    );
  }

  ListTile buildCastAction(BuildContext context, dynamic id, MediaType type) {
    return ListTile(
      leading: const Icon(Icons.cast_rounded),
      title: Text(AppLocalizations.of(context)!.buttonCast),
      onTap: () async {
        final CastDevice? device = await context.pushNamed<CastDevice>(.castSearcher);
        // final device = CastDeviceAdaptor(id: '', friendlyName: 'IPTV');
        if (device != null && context.mounted) {
          device.error.addListener(() {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(device.error.value.toString()), behavior: SnackBarBehavior.floating));
          });
          final PlaylistData data = await getPlaylistById(type, id);
          if (context.mounted) {
            await context.pushNamed(
              .castPlayer,
              arguments: {
                'data': PlaylistData(
                  themeColor: data.themeColor,
                  playlist: data.playlist,
                  activeIndex: data.activeIndex,
                ),
                'device': device,
              },
            );
          }
          device.dispose();
        }
      },
    );
  }

  ListTile buildWatchedAction(BuildContext context, MediaBase item, MediaType type) {
    return ListTile(
      title: Text(
        item.watched
            ? AppLocalizations.of(context)!.buttonMarkNotPlayed
            : AppLocalizations.of(context)!.buttonMarkPlayed,
      ),
      selected: item.watched,
      leading: const Icon(Icons.check_rounded),
      onTap: () => Api.markWatched(type, item.id, !item.watched),
    );
  }

  ListTile buildFavoriteAction(BuildContext context, MediaBase item, MediaType type) {
    return ListTile(
      title: Text(
        item.favorite
            ? AppLocalizations.of(context)!.buttonUnmarkFavorite
            : AppLocalizations.of(context)!.buttonMarkFavorite,
      ),
      selected: item.favorite,
      leading: Icon(item.favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
      onTap: () => Api.markFavorite(type, item.id, !item.favorite),
    );
  }

  ListTile buildScrapeAction(BuildContext context, MediaBase item) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buttonScraperMediaInfo),
      leading: const Icon(Icons.info_outline),
      onTap: () => context.pushNamed(.scrape, arguments: item),
    );
  }

  ListTile buildSkipFromStartAction(BuildContext context, MediaBase item, MediaType type, Duration value) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buttonSkipFromStart),
      leading: const Icon(Icons.access_time),
      onTap: () => context.pushNamed(
        .setSkipTime,
        arguments: SetSkipTimeData(skipTimeType: SkipTimeType.intro, value: value, mediaType: type, id: item.id),
      ),
    );
  }

  ListTile buildSkipFromEndAction(BuildContext context, MediaBase item, MediaType type, Duration value) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buttonSkipFromEnd),
      leading: const Icon(Icons.access_time),
      onTap: () => context.pushNamed(
        .setSkipTime,
        arguments: SetSkipTimeData(skipTimeType: SkipTimeType.ending, value: value, mediaType: type, id: item.id),
      ),
    );
  }

  ListTile buildEditMetadataAction(BuildContext context, MediaBase item, MediaType type) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(AppLocalizations.of(context)!.buttonEditMetadata),
      leading: const Icon(Icons.edit_outlined),
      onTap: () => context.pushNamed(switch (type) {
        MediaType.movie => .metadataMovie,
        MediaType.series => .metadataSeries,
        MediaType.season => .metadataSeason,
        MediaType.episode => .metadataEpisode,
      }, arguments: item),
    );
  }

  ListTile buildDownloadAction(BuildContext context, bool downloaded) {
    return ListTile(
      enabled: false,
      title: Text(
        downloaded
            ? AppLocalizations.of(context)!.downloaderLabelDownloaded
            : AppLocalizations.of(context)!.buttonDownload,
      ),
      leading: const Icon(Icons.download_outlined),
    );
  }

  ListTile buildSubtitleAction(BuildContext context, String fileId) {
    return ListTile(
      onTap: () => context.pushNamed(.subtitle, arguments: fileId),
      title: Text(AppLocalizations.of(context)!.buttonSubtitle),
      leading: const Icon(Icons.subtitles_outlined),
    );
  }

  ListTile buildHomeAction(BuildContext context, Uri uri) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buttonHome),
      leading: const Icon(Icons.home_outlined),
      onTap: () => context.pushNamed(.external, arguments: uri.toString()),
    );
  }

  ListTile buildDeleteAction(BuildContext context, GestureTapCallback? onTap) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.buttonDelete),
      leading: const Icon(Icons.delete_outline_rounded),
      onTap: onTap != null
          ? () async {
              final bool? flag = await showConfirm(context, AppLocalizations.of(context)!.deleteConfirmText);
              if ((flag ?? false) && context.mounted) {
                onTap();
              }
            }
          : null,
    );
  }
}
