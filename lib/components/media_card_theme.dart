import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class MediaCardThemeData with Diagnosticable {
  const MediaCardThemeData({this.minWidth, this.aspectRatio, this.heightExtent})
    : assert(aspectRatio == null || aspectRatio > 0);

  final double? minWidth;
  final double? aspectRatio;
  final double? heightExtent;

  Size get minSize {
    final double width = minWidth ?? 100;
    final double height = width / (aspectRatio ?? 1);
    return Size(width, height);
  }
}
