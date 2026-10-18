import 'package:flutter/material.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({
    super.key,
    this.navigatorKey,
    this.onGenerateRoute,
    this.initialRoute,
    this.onUnknownRoute,
    this.requestFocus = false,
    this.routeDirectionalTraversalEdgeBehavior = kDefaultRouteDirectionalTraversalEdgeBehavior,
  });

  final GlobalKey<NavigatorState>? navigatorKey;
  final RouteFactory? onGenerateRoute;
  final String? initialRoute;
  final RouteFactory? onUnknownRoute;
  final bool requestFocus;
  final TraversalEdgeBehavior routeDirectionalTraversalEdgeBehavior;

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (_) => navigatorKey?.currentState?.maybePop(),
      child: Navigator(
        key: navigatorKey,
        requestFocus: requestFocus,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        routeDirectionalTraversalEdgeBehavior: routeDirectionalTraversalEdgeBehavior,
      ),
    );
  }
}
