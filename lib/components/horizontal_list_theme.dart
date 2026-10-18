import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';

@immutable
class HorizontalListThemeData with Diagnosticable {
  const HorizontalListThemeData({this.padding, this.headerPadding, this.itemSpacing});

  final EdgeInsets? padding;
  final EdgeInsets? headerPadding;
  final double? itemSpacing;
}

class HorizontalListTheme extends InheritedTheme {
  const HorizontalListTheme({super.key, required this.data, required super.child});

  final HorizontalListThemeData data;

  static HorizontalListThemeData of(BuildContext context) {
    final HorizontalListTheme? theme = context.dependOnInheritedWidgetOfExactType<HorizontalListTheme>();
    return theme?.data ?? Theme.of(context).extension<AppTheme>()!.horizontalListTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return HorizontalListTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(HorizontalListTheme oldWidget) => data != oldWidget.data;
}
