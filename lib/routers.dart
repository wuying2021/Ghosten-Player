// ignore_for_file: avoid_dynamic_calls

import 'package:api/api.dart';
import 'package:flutter/material.dart';

import 'adaptive/adaptive.dart';
import 'details/playlist.dart';
import 'dialogs/episode_metadata.dart';
import 'dialogs/file_rename.dart';
import 'dialogs/live_edit.dart';
import 'dialogs/movie_metadata.dart';
import 'dialogs/scraper.dart';
import 'dialogs/season_metadata.dart';
import 'dialogs/series_metadata.dart';
import 'dialogs/storage_picker.dart';
import 'dialogs/subtitle.dart';
import 'dialogs/timer_picker.dart';
import 'medias/live_list.dart';
import 'medias/media_list.dart';
import 'medias/movie_list.dart';
import 'medias/search.dart';
import 'medias/tv_list.dart';
import 'settings/about.dart';
import 'settings/diagnostics.dart';
import 'settings/dns.dart';
import 'settings/downloader.dart';
import 'settings/help.dart';
import 'settings/home.dart';
import 'settings/library.dart';
import 'settings/log.dart';
import 'settings/other.dart';
import 'settings/play.dart';
import 'settings/player_history.dart';
import 'settings/player_kernel.dart';
import 'settings/server.dart';
import 'settings/server_add.dart';
import 'settings/shortcut.dart';
import 'settings/sponsor.dart';
import 'settings/storage.dart';
import 'settings/storage_add.dart';
import 'settings/storage_preference.dart';
import 'settings/sync.dart';
import 'settings/updater.dart';
import 'utils/navigator.dart';
import 'viewers/image_viewer.dart';
import 'viewers/player_cast.dart';
import 'viewers/singleton_player.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final RouteName? routeName = RouteName.fromStringOrNull(settings.name);
  if (routeName == null) {
    return null;
  }
  final Widget Function(dynamic)? pageBuilder = _routesMap[routeName];
  if (pageBuilder != null) {
    Widget builder(context) => pageBuilder(settings.arguments as dynamic);
    final _RouteType type = _routeByType(routeName);
    return switch (type) {
      _RouteType.material => MaterialPageRoute(builder: builder, settings: settings),
      _RouteType.noTransition => NoTransitionPageRoute(builder: builder, settings: settings),
      _RouteType.fadeIn => FadeInPageRoute(builder: builder, settings: settings),
      _RouteType.modalBottomSheet => ModalBottomSheetRoute(
        builder: builder,
        settings: settings,
        isScrollControlled: true,
        useSafeArea: true,
      ),
      _RouteType.modalBottomSheetWithHandle => ModalBottomSheetRoute(
        builder: builder,
        settings: settings,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
      ),
      _RouteType.modalBottomSheetFull => ModalBottomSheetRoute(
        builder: (context) => MediaQuery(data: MediaQuery.of(navigatorKey.currentContext!), child: builder(context)),
        constraints: const .expand(),
        settings: settings,
        isScrollControlled: true,
      ),
    };
  } else {
    return null;
  }
}

_RouteType _routeByType(RouteName routeName) => kIsTV
    ? switch (routeName) {
        .tv ||
        .movie ||
        .live ||
        .setSkipTime ||
        .settings ||
        .settingsStorage ||
        .settingsStoragePreference ||
        .settingsLibraryTv ||
        .settingsLibraryMovie ||
        .settingsHistory ||
        .settingsDownload ||
        .settingsServer ||
        .settingsDiagnostics ||
        .settingsLog ||
        .settingsOther ||
        .settingsHelp ||
        .settingsHelpDetail ||
        .settingsPlayerKernel ||
        .settingsDns ||
        .settingsDnsEdit ||
        .settingsShortcut ||
        .settingsAbout => .fadeIn,
        .player => .noTransition,
        .storagePicker => .modalBottomSheet,
        _ => .material,
      }
    : switch (routeName) {
        .metadataSeries ||
        .metadataSeason ||
        .metadataEpisode ||
        .metadataMovie ||
        .fileRename ||
        .setSkipTime ||
        .subtitleAdd ||
        .liveEdit ||
        .settingsStorageAdd ||
        .settingsStoragePreference ||
        .settingsServerAdd ||
        .settingsPlay => .modalBottomSheet,
        .castSearcher || .storagePicker => .modalBottomSheetWithHandle,
        .castPlayer => .modalBottomSheetFull,
        .tv || .movie || .live || .settings || .player => .noTransition,
        _ => .material,
      };

enum _RouteType { material, noTransition, fadeIn, modalBottomSheet, modalBottomSheetWithHandle, modalBottomSheetFull }

final Map<RouteName, Widget Function(dynamic)> _routesMap = {
  .home: (arguments) => const HomePage(),
  .tv: (arguments) => const TVListPage(),
  .movie: (arguments) => const MovieListPage(),
  .live: (arguments) => const LiveListPage(),
  .liveEdit: (arguments) => const LiveEditPage(),
  .liveDetail: (arguments) => PlaylistChannelsPage(item: arguments),
  .settings: (arguments) => const SettingsHomePage(),
  .detailSeries: (arguments) => SeriesPage(id: arguments['id'], data: arguments['data']),
  .detailSeries2: (arguments) => Series2Page(id: arguments['id'], data: arguments['data']),
  .detailSeason: (arguments) => SeasonPage(id: arguments['id'], data: arguments['data']),
  .detailEpisode: (arguments) => EpisodePage(id: arguments['id'], data: arguments['data']),
  .detailMovie: (arguments) => MoviePage(id: arguments['id'], data: arguments['data']),
  .search: (arguments) => const SearchPage(),
  .scrape: (arguments) => ScraperDialog(item: arguments),
  .media: (arguments) => MediaListPage(data: arguments),
  .player: (arguments) => SingletonPlayer(data: arguments),
  .livePlayer: (arguments) => LivePlayerPage(data: arguments),
  .castPlayer: (arguments) => PlayerCast(data: arguments['data'], device: arguments['device']),
  .castSearcher: (arguments) => const PlayerCastSearcher(),
  .subtitle: (arguments) => SubtitleManager(fileId: arguments),
  .subtitleAdd: (arguments) => const SubtitleDialog(),
  .setSkipTime: (arguments) => TimerPickerDialog(data: arguments),
  .imageViewer: (arguments) => ImageViewer(url: arguments['url'], title: arguments['title']),
  .storagePicker: (arguments) => const StoragePickDialog(),
  .metadataSeries: (arguments) => SeriesMetadata(series: arguments),
  .metadataSeason: (arguments) => SeasonMetadata(season: arguments),
  .metadataEpisode: (arguments) => EpisodeMetadata(episode: arguments),
  .metadataMovie: (arguments) => MovieMetadata(movie: arguments),
  .fileRename: (arguments) => FilenameDialog(dialogTitle: arguments['dialogTitle'], filename: arguments['filename']),
  .settingsStorage: (arguments) => const SettingsStoragePage(),
  .settingsStorageAdd: (arguments) => const SettingsStorageAddPage(),
  .settingsStoragePreference: (arguments) => SettingsStoragePreferencePage(storage: arguments),
  .settingsLibraryTv: (arguments) => const SettingsLibraryPage(type: LibraryType.tv),
  .settingsLibraryMovie: (arguments) => const SettingsLibraryPage(type: LibraryType.movie),
  .settingsPlay: (arguments) => const SettingsPlayPage(),
  .settingsHistory: (arguments) => const SystemSettingsPlayerHistory(),
  .settingsDownload: (arguments) => const SystemSettingsDownloader(),
  .settingsServer: (arguments) => const SystemSettingsServer(),
  .settingsServerAdd: (arguments) => const SettingsServerAddPage(),
  .settingsDiagnostics: (arguments) => const SettingsDiagnostics(),
  .settingsLog: (arguments) => const SettingsLogPage(),
  .settingsOther: (arguments) => const SystemSettingsOther(),
  .settingsPlayerKernel: (arguments) => const SettingsPlayerKernel(),
  .settingsSync: (arguments) => const SettingsSyncPage(),
  .settingsDns: (arguments) => const SystemSettingsDNS(),
  .settingsShortcut: (arguments) => const SystemSettingsShortcut(),
  .settingsDnsEdit: (arguments) => SystemSettingsDNSEdit(item: arguments),
  .settingsHelp: (arguments) => const SettingsHelp(),
  .settingsHelpDetail: (arguments) => HelperDetail(page: arguments),
  .settingsSponsor: (arguments) => const SettingsSponsor(),
  .settingsAbout: (arguments) => const SettingsAboutPage(),
  .settingsUpdater: (arguments) => const SettingsUpdater(),
};
