import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';

@immutable
class WrapListThemeData with Diagnosticable {
  const WrapListThemeData({this.padding, this.headerPadding, this.spacing, this.runSpacing});

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? headerPadding;
  final double? spacing;
  final double? runSpacing;
}

class WrapListTheme extends InheritedTheme {
  const WrapListTheme({super.key, required this.data, required super.child});

  final WrapListThemeData data;

  static WrapListThemeData of(BuildContext context) {
    final WrapListTheme? theme = context.dependOnInheritedWidgetOfExactType<WrapListTheme>();
    return theme?.data ?? Theme.of(context).extension<AppTheme>()!.wrapListTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return WrapListTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(WrapListTheme oldWidget) => data != oldWidget.data;
}
