import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';

@immutable
class AspectRatioGridThemeData with Diagnosticable {
  const AspectRatioGridThemeData({this.mainAxisSpacing, this.crossAxisSpacing});

  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
}

class AspectRatioGridTheme extends InheritedTheme {
  const AspectRatioGridTheme({super.key, required this.data, required super.child});

  final AspectRatioGridThemeData data;

  static AspectRatioGridThemeData of(BuildContext context) {
    final AspectRatioGridTheme? theme = context.dependOnInheritedWidgetOfExactType<AspectRatioGridTheme>();
    return theme?.data ?? Theme.of(context).extension<AppTheme>()!.aspectRatioGridTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AspectRatioGridTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(AspectRatioGridTheme oldWidget) => data != oldWidget.data;
}
