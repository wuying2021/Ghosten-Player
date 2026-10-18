import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../components/components.dart ';
import '../menus/movie.dart';
import '../utils/utils.dart';
import 'media_card.dart';

class MovieCard extends MediaCard<Movie> {
  const MovieCard({super.key, required super.item, super.size, super.direction});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      item.themeColor,
      builder: (context) => ImageCard(
        src: item.poster,
        direction: direction,
        width: size?.width,
        height: size?.height,
        title: Builder(
          builder: (context) => IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.primary, size: 12),
            child: Text.rich(
              TextSpan(
                children: [
                  if (item.voteAverage != null && item.voteAverage != 0)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Badge(
                          offset: const Offset(0, 3),
                          label: Text(item.voteAverage?.toStringAsFixed(1) ?? '', style: const TextStyle(fontSize: 9)),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  if (item.watched)
                    const WidgetSpan(
                      child: Padding(padding: EdgeInsets.only(right: 2), child: Icon(Icons.check_circle_rounded)),
                      alignment: PlaceholderAlignment.top,
                    ),
                  if (item.favorite)
                    const WidgetSpan(
                      child: Padding(padding: EdgeInsets.only(right: 2), child: Icon(Icons.favorite_rounded)),
                      alignment: PlaceholderAlignment.top,
                    ),
                  TextSpan(text: item.displayRecentTitle()),
                ],
              ),
            ),
          ),
        ),
        subtitle: Text(item.releaseDate?.format() ?? ''),
        onLongPress: () => context.showContextMenu(MovieMenu(item).buildSettingItems(context)),
        onTap: () => context.pushNamed(.detailMovie, arguments: {'id': item.id, 'data': item}),
      ),
    );
  }
}
