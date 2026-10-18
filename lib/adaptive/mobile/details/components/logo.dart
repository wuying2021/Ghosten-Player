import 'package:flutter/material.dart';

import '../../../../components/async_image.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key, this.logo});

  final String? logo;

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      bottom: false,
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: logo != null
                ? SizedBox.square(
                    dimension: 150,
                    child: AsyncImage(
                      logo!,
                      fit: BoxFit.contain,
                      needLoading: false,
                      alignment: Alignment.bottomCenter,
                    ),
                  )
                : const SizedBox(height: 150),
          ),
        ),
      ),
    );
  }
}
