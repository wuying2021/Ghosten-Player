import 'package:flutter/material.dart';

class OrientationPage extends StatelessWidget {
  const OrientationPage({super.key, required this.section1, required this.section2, this.title, this.actions});

  final Widget? section1;
  final Widget? section2;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(switch (Theme.of(context).brightness) {
                Brightness.dark => 'assets/images/bg-stripe.png',
                Brightness.light => 'assets/images/bg-stripe-light.png',
              }),
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withAlpha(0xaa),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0.2, 0.5],
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            title: title,
            actions: actions,
            titleSpacing: 32,
            actionsPadding: const EdgeInsets.only(right: 16),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Row(
            children: [
              Expanded(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: section1),
              ),
              Expanded(
                child: Scrollbar(
                  child: CustomScrollView(
                    slivers: [
                      const SliverSafeArea(bottom: false, sliver: SliverToBoxAdapter()),
                      SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 32), sliver: section2),
                      const SliverSafeArea(top: false, sliver: SliverToBoxAdapter()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
