import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'media_card.dart';

class CastCard extends MediaCard<MediaCast> {
  const CastCard({super.key, required super.item, super.size, super.onTap});

  @override
  Widget build(BuildContext context) {
    return ImageCard(
      src: item.profile,
      width: size?.width,
      height: size?.height,
      placeholder: Icon(item.gender == 1 ? Icons.person_2_rounded : Icons.person_rounded, size: 50),
      title: Text(item.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.role != null && item.role!.isNotEmpty)
            Text('${AppLocalizations.of(context)!.actAs} ${item.role}', maxLines: 2),
          if (item.episodeCount != null && item.episodeCount! > 0) Text('${item.episodeCount}集'),
        ],
      ),
      onTap: () => context.pushNamed(
        .media,
        arguments: MediaListData(
          query: MediaSearchQuery(mediaCast: [item.id]),
          type: FuzzySearchType.series,
        ),
      ),
    );
  }
}
