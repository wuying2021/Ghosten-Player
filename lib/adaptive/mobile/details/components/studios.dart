import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../utils/utils.dart';

class StudiosSection extends StatelessWidget {
  const StudiosSection({super.key, required this.studios, required this.type});

  final List<Studio> studios;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return SliverWrapList(
      header: Text(AppLocalizations.of(context)!.titleStudios),
      itemCount: studios.length,
      itemBuilder: (context, index) => FilledButton.tonal(
        onPressed: () => context.pushNamed(
          .media,
          arguments: MediaListData(
            query: MediaSearchQuery(studios: [studios[index].id]),
            type: FuzzySearchType.series,
          ),
        ),
        child: studios[index].logo != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: AsyncImage(studios[index].logo!, errorIconSize: 12, height: 12),
              )
            : Text(studios[index].name),
      ),
    );
  }
}
