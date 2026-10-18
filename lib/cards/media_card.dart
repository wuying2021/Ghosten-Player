import 'package:flutter/material.dart';

abstract class MediaCard<T> extends StatelessWidget {
  const MediaCard({super.key, required this.item, this.onTap, this.direction = .vertical, this.size});

  final T item;
  final Size? size;
  final Axis direction;
  final GestureTapCallback? onTap;
}
