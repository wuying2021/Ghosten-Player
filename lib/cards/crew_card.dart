import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'media_card.dart';

class CrewCard extends MediaCard<MediaCrew> {
  const CrewCard({super.key, required super.item, super.size, super.onTap});

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
          if (item.department != null) Text(item.department!),
          Text.rich(
            maxLines: 2,
            TextSpan(
              children: [
                if (item.job != null) TextSpan(text: item.job),
                if (item.episodeCount != null) const WidgetSpan(child: SizedBox(width: 4)),
                if (item.episodeCount != null)
                  TextSpan(text: '(${AppLocalizations.of(context)!.episodeCount(item.episodeCount!)})'),
              ],
            ),
          ),
        ],
      ),
      onTap: () => context.pushNamed(
        .media,
        arguments: MediaListData(
          query: MediaSearchQuery(mediaCrew: [item.id]),
          type: FuzzySearchType.series,
        ),
      ),
    );
  }
}
