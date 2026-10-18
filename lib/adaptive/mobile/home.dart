import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/components.dart';
import '../../dialogs/event_snack_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../routers.dart';
import '../../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;
  final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _snackBarController;

  @override
  Widget build(BuildContext context) {
    return QuitConfirm(
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Scaffold(
              appBar: switch (_tabIndex) {
                0 || 1 || 2 => AppBar(
                  systemOverlayStyle: switch (Theme.brightnessOf(context)) {
                    Brightness.dark => const SystemUiOverlayStyle(
                      systemNavigationBarIconBrightness: Brightness.light,
                      systemNavigationBarColor: Color(0x01000000),
                      statusBarIconBrightness: Brightness.light,
                      statusBarColor: Colors.transparent,
                    ),
                    Brightness.light => const SystemUiOverlayStyle(
                      systemNavigationBarIconBrightness: Brightness.dark,
                      systemNavigationBarColor: Color(0x01FFFFFF),
                      statusBarIconBrightness: Brightness.dark,
                      statusBarColor: Colors.transparent,
                    ),
                  },
                  forceMaterialTransparency: switch (_tabIndex) {
                    0 || 1 => true,
                    _ => false,
                  },
                  leading: const Center(child: Logo(size: 32)),
                  title: _tabIndex == 2 ? Text(AppLocalizations.of(context)!.homeTabLive) : null,
                  actions: [
                    IconButton.filledTonal(
                      onPressed: () {
                        if (_snackBarController != null) {
                          _snackBarController!.close();
                          _snackBarController = null;
                        } else {
                          _snackBarController = ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: EventSnackBar(),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              // margin: const EdgeInsets.all(10),
                              elevation: 2,
                              showCloseIcon: true,
                              persist: true,
                              width: 360,
                              behavior: .floating,
                            ),
                          );
                          _snackBarController!.closed.whenComplete(() {
                            _snackBarController = null;
                          });
                        }
                      },
                      icon: const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 3)),
                    ),
                    IconButton(onPressed: () => context.pushNamed(.search), icon: const Icon(Icons.search_rounded)),
                  ],
                ),
                _ => null,
              },
              extendBodyBehindAppBar: _tabIndex != 2,
              extendBody: true,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  height: 84,
                  child: Center(
                    child: Material(
                      shape: const StadiumBorder(),
                      clipBehavior: .antiAlias,
                      elevation: 4,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: NavigationBar(
                          selectedIndex: _tabIndex,
                          labelBehavior: .alwaysHide,
                          indicatorShape: const CircleBorder(),
                          onDestinationSelected: _onTabClick,
                          destinations: _destinations(context)
                              .map(
                                (destination) => NavigationDestination(
                                  label: destination.label,
                                  icon: Icon(destination.icon),
                                  selectedIcon: Icon(destination.selectedIcon),
                                  tooltip: '',
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: AppNavigator(
                initialRoute: RouteName.tv.name,
                navigatorKey: _homeNavigatorKey,
                onGenerateRoute: onGenerateRoute,
              ),
            ),
          ),
          // Flexible(
          //   flex: 2,
          //   child: AppNavigator(
          //     // navigatorKey: _homeNavigatorKey,
          //     routeDirectionalTraversalEdgeBehavior: .parentScope,
          //     onUnknownRoute: (_) => MaterialPageRoute(builder: (context) => const Scaffold(body: NoData())),
          //     onGenerateRoute: onGenerateRoute,
          //   ),
          // ),
        ],
      ),
    );
  }

  List<_TabDestination> _destinations(BuildContext context) {
    return [
      _TabDestination(AppLocalizations.of(context)!.homeTabTV, Icons.tv_outlined, Icons.tv),
      _TabDestination(AppLocalizations.of(context)!.homeTabMovie, Icons.movie_creation_outlined, Icons.movie_creation),
      _TabDestination(AppLocalizations.of(context)!.homeTabLive, Icons.live_tv_outlined, Icons.live_tv),
      _TabDestination(AppLocalizations.of(context)!.homeTabSettings, Icons.settings_outlined, Icons.settings),
    ];
  }

  void _onTabClick(int index) {
    if (_tabIndex == index) {
      return;
    }
    setState(() => _tabIndex = index);
    _homeNavigatorKey.currentContext!.pushReplacementNamed(switch (index) {
      0 => .tv,
      1 => .movie,
      2 => .live,
      3 => .settings,
      _ => throw UnimplementedError(),
    });
  }
}

class _TabDestination {
  const _TabDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
