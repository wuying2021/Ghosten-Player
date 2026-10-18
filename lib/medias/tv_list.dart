import 'package:api/api.dart';
import 'package:flutter/material.dart' hide IconButton;

import '../../cards/cards.dart';
import '../../components/components.dart';
import '../../extensions/extensions.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';
import 'components/media_scaffold.dart';
import 'components/recommendation_carousel.dart';

class TVListPage extends StatefulWidget {
  const TVListPage({super.key});

  @override
  State<TVListPage> createState() => _TVListPageState();
}

class _TVListPageState extends State<TVListPage> {
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
            future: Api.tvRecommendation(),
            loadingBuilder: (context, snapshot) => const SliverToBoxAdapter(child: CarouselItem()),
            builder: (context, snapshot) => RecommendationCarousel(
              onChanged: (index) => _backdrop.value = snapshot.requireData[index].backdrop,
              noDataBuilder: (context) => FilledButton(
                onPressed: () => context.pushNamed(.settingsLibraryTv),
                child: Text(AppLocalizations.of(context)!.settingsItemTV),
              ),
              items: snapshot.requireData,
              onPressed: (index) => toMediaPlayer(context, .series, snapshot.requireData[index].id),
            ),
          ),
          MediaChannel(
            label: AppLocalizations.of(context)!.watchNow,
            future: Api.tvSeriesNextToPlayQueryAll(),
            cardStyle: theme.episodeCardTheme,
            builder: (context, item, size) => EpisodeWatchNowCard(item: item, size: size),
            loadingBuilder: (context, size) => ImageCardPlaceholder(size: size),
            onTap: () => context.pushNamed(.settingsHistory),
          ),
          ...[
            ChannelItem(
              label: AppLocalizations.of(context)!.tagFavorite,
              query: const MediaSearchQuery(
                sort: SortType.createAt,
                direction: SortDirection.desc,
                favorite: true,
                limit: 15,
              ),
            ),
            ChannelItem(
              label: AppLocalizations.of(context)!.tagNewAdd,
              query: const MediaSearchQuery(sort: SortType.createAt, direction: SortDirection.desc, limit: 15),
            ),
            ChannelItem(
              label: AppLocalizations.of(context)!.tagNewRelease,
              query: const MediaSearchQuery(sort: SortType.airDate, direction: SortDirection.desc, limit: 15),
            ),
          ].map(
            (item) => MediaChannel(
              label: item.label,
              cardStyle: theme.seriesCardTheme,
              future: Api.tvSeriesQueryAll(item.query).then((data) => data.data),
              builder: (context, item, size) => SeriesCard(item: item, size: size),
              onTap: () => context.pushNamed(
                .media,
                arguments: MediaListData(type: .series, query: item.query),
              ),
              loadingBuilder: (context, size) => ImageCardPlaceholder(size: size),
            ),
          ),
          MediaGridChannel(
            label: AppLocalizations.of(context)!.tagAll,
            cardStyle: theme.seriesCardTheme,
            headerPadding: theme.horizontalListTheme.headerPadding!,
            contentPadding: theme.horizontalListTheme.padding!,
            onQuery: (index) => Api.tvSeriesQueryAll(MediaSearchQuery(limit: 30, offset: 30 * index, sort: .title)),
            itemBuilder: (context, item, size) => SeriesCard(item: item, size: size),
          ),
        ],
      ),
    );
  }
}
