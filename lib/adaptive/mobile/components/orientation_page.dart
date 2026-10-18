import 'package:flutter/material.dart';

class OrientationPage extends StatelessWidget {
  const OrientationPage({super.key, this.section1, this.section2, this.title, this.actions});

  final Widget? section1;
  final Widget? section2;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return DeviceOrientationBuilder(
      builder: (context, orientation) {
        switch (orientation) {
          case Orientation.portrait:
            return Scaffold(
              appBar: AppBar(forceMaterialTransparency: true, title: title, actions: actions),
              extendBodyBehindAppBar: true,
              body: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    const SliverSafeArea(bottom: false, sliver: SliverToBoxAdapter()),
                    SliverToBoxAdapter(child: section1),
                    const SliverToBoxAdapter(child: Divider()),
                    ?section2,
                    const SliverSafeArea(top: false, sliver: SliverToBoxAdapter()),
                  ],
                ),
              ),
            );
          case Orientation.landscape:
            return Scaffold(
              appBar: AppBar(forceMaterialTransparency: true, title: title, actions: actions),
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              body: Row(
                children: [
                  Expanded(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: section1),
                  ),
                  const VerticalDivider(indent: 60, endIndent: 60),
                  Expanded(
                    child: Scrollbar(
                      child: CustomScrollView(
                        slivers: [
                          if (section2 != null)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              sliver: SliverSafeArea(sliver: section2!),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
