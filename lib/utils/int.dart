extension IntExtension on int {
  String toSizeDisplay() {
    return switch (this) {
      < 1 << 10 => '$this B',
      < 1 << 20 => '${double.parse((this / (1 << 10)).toStringAsFixed(2))} KB',
      < 1 << 30 => '${double.parse((this / (1 << 20)).toStringAsFixed(2))} MB',
      _ => '${double.parse((this / (1 << 30)).toStringAsFixed(2))} GB',
    };
  }

  String toNetworkSpeed() {
    return '${toSizeDisplay()}/s';
  }
}
