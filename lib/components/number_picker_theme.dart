import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';

@immutable
class NumberPickerThemeData with Diagnosticable {
  const NumberPickerThemeData({this.alwaysShow = true});

  final bool alwaysShow;
}

class NumberPickerTheme extends InheritedTheme {
  const NumberPickerTheme({super.key, required this.data, required super.child});

  final NumberPickerThemeData data;

  static NumberPickerThemeData of(BuildContext context) {
    final NumberPickerTheme? theme = context.dependOnInheritedWidgetOfExactType<NumberPickerTheme>();
    return theme?.data ?? Theme.of(context).extension<AppTheme>()!.numberPickerTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return NumberPickerTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(NumberPickerTheme oldWidget) => data != oldWidget.data;
}
