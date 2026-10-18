import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../cards/cards.dart';
import '../../components/components.dart';
import '../../extensions/extensions.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';
import '../models/models.dart';
import 'components/media_scaffold.dart';
import 'components/recommendation_carousel.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _backdrop = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _backdrop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: MediaScaffold(
        backdrop: _backdrop,
        slivers: [
          FutureBuilderSliverHandler(
            future: Api.movieRecommendation(),
            loadingBuilder: (context, snapshot) => const SliverToBoxAdapter(child: CarouselItem()),
            builder: (context, snapshot) => RecommendationCarousel(
              onChanged: (index) => _backdrop.value = snapshot.requireData[index].backdrop,
              noDataBuilder: (context) => FilledButton(
                onPressed: () => context.pushNamed(.settingsLibraryMovie),
                child: Text(AppLocalizations.of(context)!.settingsItemMovie),
              ),
              items: snapshot.requireData,
              onPressed: (index) => toMediaPlayer(context, .movie, snapshot.requireData[index].id),
            ),
          ),
          MediaChannel(
            label: AppLocalizations.of(context)!.watchNow,
            cardStyle: theme.movieCardTheme,
            future: Api.movieNextToPlayQueryAll(),
            builder: (context, item, size) => _buildRecentMediaCard(context, item, size),
            loadingBuilder: (context, size) => ImageCardPlaceholder(size: size),
            onTap: () => context.pushNamed(.settingsHistory),
          ),
          MediaChannel(
            label: AppLocalizations.of(context)!.tagFavorite,
            cardStyle: theme.movieCardTheme,
            future: Api.movieQueryAll(
              const MediaSearchQuery(sort: SortType.createAt, direction: SortDirection.desc, favorite: true, limit: 15),
            ).then((data) => data.data),
            builder: (context, item, size) => MovieCard(item: item, size: size),
            loadingBuilder: (context, size) => ImageCardPlaceholder(size: size),
          ),
          MediaChannel(
            label: AppLocalizations.of(context)!.tagNewAdd,
            cardStyle: theme.movieCardTheme,
            future: Api.movieQueryAll(
              const MediaSearchQuery(sort: SortType.createAt, direction: SortDirection.desc, limit: 15),
            ).then((data) => data.data),
            onTap: () => context.pushNamed(
              .media,
              arguments: const MediaListData(
                type: .movie,
                query: MediaSearchQuery(sort: SortType.createAt, direction: SortDirection.desc, limit: 15),
              ),
            ),
            builder: (context, item, size) => MovieCard(item: item, size: size),
            loadingBuilder: (context, size) => ImageCardPlaceholder(size: size),
          ),
          MediaChannel(
            label: AppLocalizations.of(context)!.tagNewRelease,
            cardStyle: theme.movieCardTheme,
            future: Api.movieQueryAll(
              const MediaSearchQuery(sort: SortType.createAt, direction: SortDirection.desc, limit: 15),
            ).then((data) => data.data),
            builder: (context, item, size) => MovieCard(item: item, size: size),
            loadingBuilder: (context, size) => ImageCardPlaceholder(size: size),
          ),
          MediaGridChannel(
            label: AppLocalizations.of(context)!.tagAll,
            cardStyle: theme.movieCardTheme,
            headerPadding: theme.horizontalListTheme.headerPadding!,
            contentPadding: theme.horizontalListTheme.padding!,
            onQuery: (index) => Api.movieQueryAll(MediaSearchQuery(limit: 30, offset: 30 * index)),
            itemBuilder: (context, item, size) => MovieCard(item: item, size: size),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMediaCard(BuildContext context, Movie item, Size size) {
    return ImageCard(
      src: item.poster,
      width: size.width,
      height: size.height,
      title: Text(item.displayRecentTitle()),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (item.lastPlayedTime != null)
            Text(
              AppLocalizations.of(context)!.timeAgo(item.lastPlayedTime!.fromNow().fromNowFormat(context)),
              style: Theme.of(context).textTheme.labelSmall,
            )
          else
            const Spacer(),
          if (item.lastPlayedPosition != null && item.duration != null && item.duration!.inSeconds != 0)
            Text('${(item.lastPlayedPosition!.inSeconds / item.duration!.inSeconds * 100).toStringAsFixed(1)}%'),
        ],
      ),
      onTap: () => toMediaPlayer(context, .movie, item.id),
      floating: item.lastPlayedPosition != null && item.duration != null && item.duration!.inSeconds != 0
          ? Align(
              alignment: const Alignment(0, 0.95),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: LinearProgressIndicator(
                  value: item.lastPlayedPosition!.inSeconds / item.duration!.inSeconds,
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(3),
                  minHeight: 3,
                ),
              ),
            )
          : null,
    );
  }
}
