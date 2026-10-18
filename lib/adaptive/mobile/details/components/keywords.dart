import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../utils/utils.dart';

class KeywordsSection extends StatelessWidget {
  const KeywordsSection({super.key, required this.keywords, required this.type});

  final MediaType type;
  final List<Keyword> keywords;

  @override
  Widget build(BuildContext context) {
    return SliverWrapList(
      header: Text(AppLocalizations.of(context)!.titleKeywords),
      itemCount: keywords.length,
      itemBuilder: (context, index) => FilledButton.tonal(
        style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
        onPressed: () => context.pushNamed(
          .media,
          arguments: MediaListData(
            query: MediaSearchQuery(keywords: [keywords[index].id]),
            type: FuzzySearchType.series,
          ),
        ),
        child: Text(keywords[index].name),
      ),
    );
  }
}
