import 'package:flutter/material.dart';

class PlaceholderRRect extends StatelessWidget {
  const PlaceholderRRect({super.key, this.width, this.height, this.borderRadius});

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
      ),
    );
  }
}

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key, this.width, this.height, this.padding, this.borderRadius});

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Icon(Icons.image_outlined, size: 50, color: Theme.of(context).colorScheme.surfaceContainerHigh),
        ),
      ),
    );
  }
}
