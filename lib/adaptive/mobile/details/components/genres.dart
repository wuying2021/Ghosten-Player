import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../utils/utils.dart';

class GenresSection extends StatelessWidget {
  const GenresSection({super.key, required this.genres, required this.type});

  final List<Genre> genres;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return SliverWrapList(
      header: Text(AppLocalizations.of(context)!.titleGenres),
      itemCount: genres.length,
      itemBuilder: (context, index) => FilledButton.tonal(
        onPressed: () => context.pushNamed(
          .media,
          arguments: MediaListData(
            query: MediaSearchQuery(genres: [genres[index].id]),
            type: switch (type) {
              MediaType.movie => .movie,
              MediaType.series => .series,
              _ => throw UnimplementedError(),
            },
          ),
        ),
        child: Text(genres[index].name),
      ),
    );
  }
}
