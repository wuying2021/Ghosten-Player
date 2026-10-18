import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../components/components.dart ';
import '../../../../models/models.dart';
import '../../../../utils/utils.dart';

class GenresSection extends StatelessWidget {
  const GenresSection({super.key, required this.genres, required this.type});

  final List<Genre> genres;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButtonTheme.of(context).style!.copyWith(
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 4, vertical: 4)),
            minimumSize: const WidgetStatePropertyAll(Size.zero),
            tapTargetSize: .shrinkWrap,
            visualDensity: .compact,
            textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelSmall),
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          scrollDirection: .horizontal,
          itemCount: genres.length,
          itemBuilder: (context, index) => TextButton(
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
          separatorBuilder: (context, index) => Gap.hSM,
        ),
      ),
    );
  }
}
