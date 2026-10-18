import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';

@immutable
class MediaListThemeData with Diagnosticable {
  const MediaListThemeData({
    this.automaticallyImplyLeading = true,
    this.expandedHeight,
    this.titleTextStyle,
    this.titlePadding,
    this.forceMaterialTransparency = false,
    this.contentPadding,
  });

  final bool forceMaterialTransparency;
  final bool automaticallyImplyLeading;
  final double? expandedHeight;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
}

class MediaListTheme extends InheritedTheme {
  const MediaListTheme({super.key, required this.data, required super.child});

  final MediaListThemeData data;

  static MediaListThemeData of(BuildContext context) {
    final MediaListTheme? theme = context.dependOnInheritedWidgetOfExactType<MediaListTheme>();
    return theme?.data ?? Theme.of(context).extension<AppTheme>()!.mediaListTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MediaListTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MediaListTheme oldWidget) => data != oldWidget.data;
}
