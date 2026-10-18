import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'async_image.dart';

class CarouselBackground extends StatelessWidget {
  const CarouselBackground({super.key, required this.src, this.isActive = true});

  final String? src;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .passthrough,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: PageTransitionSwitcher(
            duration: const Duration(seconds: 2),
            layoutBuilder: (List<Widget> entries) => Stack(fit: StackFit.expand, children: entries),
            transitionBuilder:
                (Widget child, Animation<double> primaryAnimation, Animation<double> secondaryAnimation) {
                  return SharedAxisTransition(
                    animation: primaryAnimation.drive(CurveTween(curve: Curves.easeOut)),
                    secondaryAnimation: secondaryAnimation.drive(CurveTween(curve: Curves.easeOut)),
                    transitionType: SharedAxisTransitionType.horizontal,
                    fillColor: Colors.transparent,
                    child: child,
                  );
                },
            child: Container(
              key: ValueKey(src),
              child: src != null
                  ? AsyncImage(src!, errorWidget: (_, _, _) => _buildPlaceholderImage(context))
                  : _buildPlaceholderImage(context),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(1.2, -5.0),
              colors: isActive
                  ? [
                      Theme.of(context).scaffoldBackgroundColor.withAlpha(0x00),
                      Theme.of(context).scaffoldBackgroundColor.withAlpha(0xFF),
                    ]
                  : [
                      Theme.of(context).scaffoldBackgroundColor.withAlpha(0xCC),
                      Theme.of(context).scaffoldBackgroundColor.withAlpha(0xFF),
                    ],
              radius: 3,
              stops: const [0.7, 1],
            ),
          ),
        ),
      ],
    );
  }

  Image _buildPlaceholderImage(BuildContext context) {
    return Image.asset(
      'assets/images/${switch (Theme.of(context).brightness) {
        Brightness.dark => 'bg-pixel.webp',
        Brightness.light => 'bg-pixel-light.webp',
      }}',
      repeat: ImageRepeat.repeat,
    );
  }
}
