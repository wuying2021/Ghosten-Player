import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/shortcut_tv.dart';
import '../../routers.dart';
import '../../utils/utils.dart';
import 'components/_home_tab.dart';
import 'tv.dart';

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final initialRoute = ValueNotifier<RouteName>(.settings);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final ShortcutTV shortcuts = context.watch<ShortcutTV>();
    return QuitConfirm(
      child: Focus(
        skipTraversal: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent || event is KeyRepeatEvent) {
            if (event.logicalKey == shortcuts.menu) {
              if (!homeScaffoldKey.currentState!.isEndDrawerOpen) {
                homeScaffoldKey.currentState!.openEndDrawer();
                return KeyEventResult.handled;
              }
            }
          }
          return KeyEventResult.ignored;
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, r) {
            if (didPop) {
              return;
            }
            if (homeScaffoldKey.currentState!.isEndDrawerOpen) {
              if (!settingNavigatorKey.currentState!.canPop()) {
                homeScaffoldKey.currentState!.closeEndDrawer();
              }
            }
          },
          child: Scaffold(
            key: homeScaffoldKey,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: _HomeAppbar(
              onTabChange: (index) => _homeNavigatorKey.currentContext!.pushReplacementNamed(switch (index) {
                0 => .tv,
                1 => .movie,
                2 => .live,
                _ => throw UnimplementedError(),
              }),
            ),
            endDrawer: Container(
              width: 360,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: ListenableBuilder(
                listenable: initialRoute,
                builder: (context, _) {
                  return AppNavigator(
                    navigatorKey: settingNavigatorKey,
                    initialRoute: initialRoute.value.name,
                    onGenerateRoute: onGenerateRoute,
                  );
                },
              ),
            ),
            body: AppNavigator(
              navigatorKey: _homeNavigatorKey,
              initialRoute: RouteName.tv.name,
              routeDirectionalTraversalEdgeBehavior: .parentScope,
              onGenerateRoute: onGenerateRoute,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeAppbar extends StatefulWidget implements PreferredSizeWidget {
  const _HomeAppbar({required this.onTabChange});

  final ValueChanged<int> onTabChange;

  @override
  State<_HomeAppbar> createState() => _HomeAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends State<_HomeAppbar> {
  int _activeIndex = 0;
  bool _show = true;
  ScrollNotificationObserverState? _scrollNotificationObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    final ScaffoldState? scaffoldState = Scaffold.maybeOf(context);

    if (scaffoldState != null && (scaffoldState.isDrawerOpen || scaffoldState.isEndDrawerOpen)) {
      return;
    }
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && !Scaffold.of(context).isEndDrawerOpen) {
      final bool oldShow = _show;
      final ScrollMetrics metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
        case AxisDirection.down:
          _show = metrics.extentBefore < 100;
        case AxisDirection.right:
        case AxisDirection.left:
          break;
      }
      if (_show != oldShow) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      reverse: _show,
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          fillColor: Colors.transparent,
          child: child,
        );
      },
      child: _show
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: switch (Theme.of(context).brightness) {
                    Brightness.dark => [Colors.black38, Colors.transparent],
                    Brightness.light => [Colors.white38, Colors.white.withAlpha(0)],
                  },
                  begin: .topCenter,
                  end: .bottomCenter,
                ),
              ),
              child: AppBar(
                forceMaterialTransparency: true,
                leading: IconButton.filledTonal(
                  onPressed: () => context.pushNamed(.search),
                  icon: const Icon(Icons.search_rounded, size: 20),
                ),
                leadingWidth: 136,
                titleSpacing: 40,
                title: HomeTabs(
                  activeIndex: _activeIndex,
                  tabs: [
                    AppLocalizations.of(context)!.homeTabTV,
                    AppLocalizations.of(context)!.homeTabMovie,
                    AppLocalizations.of(context)!.homeTabLive,
                  ],
                  onTabChange: (index) {
                    _activeIndex = index;
                    widget.onTabChange(index);
                  },
                ),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 48),
                actions: [
                  IconButton(
                    onPressed: () => homeScaffoldKey.currentState?.openEndDrawer(),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                  const SizedBox(width: 12),
                  const Clock(),
                ],
              ),
            )
          : AppBar(forceMaterialTransparency: true, actions: const [SizedBox()]),
    );
  }
}
