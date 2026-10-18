import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../adaptive/adaptive.dart';
import '../platform_api.dart';

extension NavigatorExtension on BuildContext {
  Future<T?> pushNamed<T extends Object?>(RouteName routeName, {Object? arguments}) {
    if (routeName == .external) {
      return launchUrlString(
        arguments! as String,
        mode: .inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      ).then((_) => null);
    }
    return _resolveRoute(
      this,
      routeName,
      (navigatorState) => navigatorState.pushNamed(routeName.name, arguments: arguments),
    );
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    RouteName routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _resolveRoute(
      this,
      routeName,
      (navigatorState) =>
          navigatorState.pushReplacementNamed<dynamic, TO>(routeName.name, arguments: arguments, result: result),
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    RouteName routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _resolveRoute(
      this,
      routeName,
      (navigatorState) => navigatorState.pushNamedAndRemoveUntil(routeName.name, predicate, arguments: arguments),
    );
  }
}

Future<T?> _resolveRoute<T extends Object?>(
  BuildContext context,
  RouteName routeName,
  Future<dynamic> Function(NavigatorState navigatorState) runner,
) async {
  NavigatorState state = Navigator.of(context);

  if (kIsTV) {
    switch (routeName) {
      case .player:
      case .livePlayer:
      case .castPlayer:
      case .castSearcher:
      case .liveEdit:
      case .storagePicker:
      case .imageViewer:
      case .detailSeries:
      case .detailSeries2:
      case .detailSeason:
      case .detailEpisode:
      case .detailMovie:
      case .search:
      case .scrape:
      case .media:
      case .subtitleAdd:
      case .metadataSeries:
      case .metadataSeason:
      case .metadataEpisode:
      case .metadataMovie:
      case .fileRename:
      case .settingsStorageAdd:
      case .settingsPlay:
      case .settingsServerAdd:
      case .settingsSponsor:
      case .settingsSync:
      case .settingsUpdater:
        state = Navigator.of(context, rootNavigator: true);
      case .settingsHistory:
      case .settingsLibraryTv:
      case .settingsLibraryMovie:
        Scaffold.of(context).openEndDrawer();
        await WidgetsBinding.instance.endOfFrame;
        state = Navigator.of(settingNavigatorKey.currentContext!);
      default:
    }
  } else {
    switch (routeName) {
      case .tv:
      case .movie:
      case .live:
      case .settings:
        state = Navigator.of(context);
      default:
        state = Navigator.of(context, rootNavigator: true);
    }
  }
  if (routeName == .player) {
    await _setPreferredOrientations(true);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  final dynamic re = await runner(state);
  if (routeName == .player) {
    await _setPreferredOrientations(false);
    // TODO(GhostenEditor): bug when SDK < 29
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  return re as T?;
}

Future<void> _setPreferredOrientations(bool fullscreen) {
  if (PlatformApi.isAndroidPhone()) {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      if (fullscreen) DeviceOrientation.landscapeLeft,
      if (fullscreen) DeviceOrientation.landscapeRight,
    ]);
  } else {
    return Future.value();
  }
}

enum RouteName {
  home,
  tv,
  movie,
  live,
  liveEdit,
  liveDetail,
  settings,
  detailSeries,
  detailSeries2,
  detailSeason,
  detailEpisode,
  detailMovie,
  search,
  scrape,
  media,
  player,
  livePlayer,
  castPlayer,
  castSearcher,
  subtitle,
  subtitleAdd,
  setSkipTime,
  imageViewer,
  storagePicker,
  metadataSeries,
  metadataSeason,
  metadataEpisode,
  metadataMovie,
  fileRename,
  settingsStorage,
  settingsStorageAdd,
  settingsStoragePreference,
  settingsLibraryTv,
  settingsLibraryMovie,
  settingsPlay,
  settingsHistory,
  settingsDownload,
  settingsServer,
  settingsServerAdd,
  settingsDiagnostics,
  settingsLog,
  settingsOther,
  settingsPlayerKernel,
  settingsSync,
  settingsDns,
  settingsDnsEdit,
  settingsShortcut,
  settingsHelp,
  settingsHelpDetail,
  settingsSponsor,
  settingsAbout,
  settingsUpdater,
  external;

  static RouteName? fromStringOrNull(String? s) {
    return RouteName.values.firstWhereOrNull((item) => item.name == s);
  }
}

Future<T?> navigateToSlideLeft<T extends Object?>(BuildContext context, Widget page) {
  return Navigator.of(context).push(FadeInPageRoute<T>(builder: (context) => page));
}

class NoTransitionPageRoute<T> extends PageRoute<T> {
  NoTransitionPageRoute({required this.builder, super.settings});

  final WidgetBuilder builder;

  @override
  final Color? barrierColor = null;

  @override
  final String? barrierLabel = null;

  @override
  final bool maintainState = true;
  @override
  final Duration transitionDuration = Duration.zero;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }
}

class FadeInPageRoute<T> extends PageRoute<T> {
  FadeInPageRoute({required this.builder, super.settings});

  @override
  final Duration transitionDuration = const Duration(milliseconds: 650);

  @override
  final Duration reverseTransitionDuration = const Duration(milliseconds: 650);

  @override
  final bool opaque = true;

  @override
  final bool barrierDismissible = false;

  @override
  final Color? barrierColor = null;

  @override
  final String? barrierLabel = null;

  @override
  final bool maintainState = true;

  final WidgetBuilder builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: Colors.transparent,
      child: child,
    );
  }
}
