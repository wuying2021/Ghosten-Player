import 'package:flutter/material.dart';

import '../constants.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final int? cacheSize = size != null ? (MediaQuery.of(context).devicePixelRatio * size!).round() : null;
    return Image.asset(assetsLogo, width: size, height: size, cacheWidth: cacheSize, cacheHeight: cacheSize);
  }
}
