import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../utils/player.dart';

class TopButtons<T extends MediaBase> extends StatelessWidget {
  const TopButtons({super.key, required this.item, required this.type});

  final T item;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      sliver: SliverToBoxAdapter(
        child: IconTheme(
          data: IconTheme.of(context).copyWith(size: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              if (item.watched)
                IconButton.filled(
                  onPressed: () => Api.markWatched(type, item.id, !item.watched),
                  icon: const Icon(Icons.check_rounded),
                )
              else
                IconButton.filledTonal(
                  onPressed: () => Api.markWatched(type, item.id, !item.watched),
                  icon: const Icon(Icons.check_rounded),
                ),
              IconButton.filled(
                isSelected: true,
                onPressed: () => toMediaPlayer(context, type, item.id),
                icon: const Icon(Icons.play_arrow_rounded, size: 36),
              ),
              if (item.favorite)
                IconButton.filled(
                  onPressed: () => Api.markFavorite(type, item.id, !item.favorite),
                  selectedIcon: const Icon(Icons.favorite_rounded),
                  icon: const Icon(Icons.favorite_border_rounded),
                )
              else
                IconButton.filledTonal(
                  onPressed: () => Api.markFavorite(type, item.id, !item.favorite),
                  selectedIcon: const Icon(Icons.favorite_rounded),
                  icon: const Icon(Icons.favorite_border_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
