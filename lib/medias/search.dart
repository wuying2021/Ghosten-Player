import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../cards/cards.dart';
import '../../components/components.dart';
import '../../extensions/extensions.dart';
import '../../l10n/app_localizations.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.autofocus = false});

  final bool autofocus;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final _clearFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _clearFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return Scaffold(
      appBar: AppBar(
        title: SearchBox(autofocus: true, controller: _searchController, onSubmitted: (_) => setState(() {})),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(AppLocalizations.of(context)!.search),
          ),
        ],
      ),
      body: FutureBuilderHandler(
        future: Api.searchFuzzy(MediaSearchQuery(search: _searchController.text, limit: 15)),
        builder: (context, snapshot) => Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverHorizontalList(
                header: Text('${AppLocalizations.of(context)!.homeTabMovie} (${snapshot.requireData.movies.count})'),
                cardStyle: theme.movieCardTheme,
                itemCount: snapshot.requireData.movies.data.length,
                itemBuilder: (context, index, size) =>
                    MovieCard(item: snapshot.requireData.movies.data[index], size: size),
                onTap: snapshot.requireData.movies.count > snapshot.requireData.movies.limit
                    ? () => context.pushNamed(
                        .media,
                        arguments: MediaListData(
                          query: MediaSearchQuery(search: _searchController.text),
                          type: FuzzySearchType.movie,
                        ),
                      )
                    : null,
              ),
              SliverHorizontalList(
                header: Text('${AppLocalizations.of(context)!.homeTabTV} (${snapshot.requireData.series.count})'),
                cardStyle: theme.seriesCardTheme,
                itemCount: snapshot.requireData.series.data.length,
                itemBuilder: (context, index, size) =>
                    SeriesCard(item: snapshot.requireData.series.data[index], size: size),
                onTap: snapshot.requireData.series.count > snapshot.requireData.series.limit
                    ? () => context.pushNamed(
                        .media,
                        arguments: MediaListData(
                          query: MediaSearchQuery(search: _searchController.text),
                          type: FuzzySearchType.series,
                        ),
                      )
                    : null,
              ),
              SliverHorizontalList(
                header: Text(
                  '${AppLocalizations.of(context)!.formLabelEpisode} (${snapshot.requireData.episodes.count})',
                ),
                cardStyle: theme.episodeCardTheme,
                itemCount: snapshot.requireData.episodes.data.length,
                itemBuilder: (context, index, size) {
                  final TVEpisode item = snapshot.requireData.episodes.data[index];
                  return EpisodeWatchNowCard(
                    item: item,
                    size: size,
                    onTap: () => context.pushNamed(.detailEpisode, arguments: {'id': item.id, 'data': item}),
                  );
                },
                onTap: snapshot.requireData.episodes.count > snapshot.requireData.episodes.limit
                    ? () => context.pushNamed(
                        .media,
                        arguments: MediaListData(
                          query: MediaSearchQuery(search: _searchController.text),
                          type: FuzzySearchType.episode,
                        ),
                      )
                    : null,
              ),
              SliverHorizontalList(
                header: Text('${AppLocalizations.of(context)!.titleCasts} (${snapshot.requireData.mediaCast.count})'),
                cardStyle: theme.castCardTheme,
                itemCount: snapshot.requireData.mediaCast.data.length,
                itemBuilder: (context, index, size) =>
                    CastCard(item: snapshot.requireData.mediaCast.data[index], size: size),
                onTap: snapshot.requireData.mediaCast.count > snapshot.requireData.mediaCast.limit
                    ? () => context.pushNamed(
                        .media,
                        arguments: MediaListData(
                          query: MediaSearchQuery(search: _searchController.text),
                          type: FuzzySearchType.cast,
                        ),
                      )
                    : null,
              ),
              SliverHorizontalList(
                header: Text('${AppLocalizations.of(context)!.titleCrews} (${snapshot.requireData.mediaCrew.count})'),
                cardStyle: theme.crewCardTheme,
                itemCount: snapshot.requireData.mediaCrew.data.length,
                itemBuilder: (context, index, size) =>
                    CrewCard(item: snapshot.requireData.mediaCrew.data[index], size: size),
                onTap: snapshot.requireData.mediaCrew.count > snapshot.requireData.mediaCrew.limit
                    ? () => context.pushNamed(
                        .media,
                        arguments: MediaListData(
                          query: MediaSearchQuery(search: _searchController.text),
                          type: FuzzySearchType.crew,
                        ),
                      )
                    : null,
              ),
              const SliverSafeArea(top: false, sliver: SliverToBoxAdapter()),
            ],
          ),
        ),
      ),
    );
  }
}
