import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../components/components.dart ';
import '../menus/series.dart';
import '../utils/utils.dart';
import 'media_card.dart';

class SeriesCard extends MediaCard<TVSeries> {
  const SeriesCard({super.key, required super.item, super.size, super.direction});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      item.themeColor,
      builder: (context) => ImageCard(
        src: item.poster,
        width: size?.width,
        height: size?.height,
        direction: direction,
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
        subtitle: Text(item.firstAirDate?.format() ?? ''),
        onLongPress: () => context.showContextMenu(SeriesMenu(item).buildSettingItems(context)),
        onTap: () => context.pushNamed(.detailSeries, arguments: {'id': item.id, 'data': item}),
      ),
    );
  }
}
