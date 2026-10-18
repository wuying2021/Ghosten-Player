import 'package:flutter/material.dart';

const double _defaultGapSizeSm = 8;
const double _defaultGapSizeMd = 12;
const double _defaultGapSizeLg = 16;

class Gap extends StatelessWidget {
  const Gap({super.key, this.width, this.height});

  const Gap.vertical(double size, {super.key}) : width = null, height = size;

  const Gap.horizontal(double size, {super.key}) : width = size, height = null;
  final double? width;
  final double? height;

  static const vLG = Gap.vertical(_defaultGapSizeLg);
  static const vMD = Gap.vertical(_defaultGapSizeMd);
  static const vSM = Gap.vertical(_defaultGapSizeSm);
  static const hLG = Gap.horizontal(_defaultGapSizeLg);
  static const hMD = Gap.horizontal(_defaultGapSizeMd);
  static const hSM = Gap.horizontal(_defaultGapSizeSm);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
