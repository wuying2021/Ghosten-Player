import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../cards/cards.dart';
import '../../../components/components.dart';
import '../../../menus/season.dart';
import 'components/components.dart';
import 'titles/season.dart';

class SeasonPage extends StatefulWidget {
  const SeasonPage({super.key, required this.id, this.data});

  final dynamic id;
  final TVSeason? data;

  @override
  State<SeasonPage> createState() => _SeasonPageState();
}

class _SeasonPageState extends State<SeasonPage> {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([
      EventDispatcher.where(type: .season, subType: .update, id: widget.id).doOnData((_) => setState(() {})),
      EventDispatcher.where(
        type: .season,
        subType: .delete,
        id: widget.id,
      ).doOnData((_) => Navigator.of(context).pop()),
    ]).listen((_) {});
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext rootContext) {
    return FutureBuilderHandler(
      initialData: widget.data,
      future: Api.tvSeasonQueryById(widget.id),
      errorBuilder: (context, snapshot) => Scaffold(
        body: Center(child: ErrorMessage(error: snapshot.error)),
      ),
      builder: (context, snapshot) {
        final TVSeason item = snapshot.requireData;
        return DetailScaffold(
          onRefresh: () async => setState(() {}),
          imageAspectRatio: 0.8,
          themeColor: item.themeColor,
          menus: SeasonMenu(item),
          slivers: [
            const SliverSafeArea(bottom: false, sliver: SliverToBoxAdapter()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Card(
                        child: item.poster != null
                            ? AsyncImage(item.poster!, viewable: true)
                            : Icon(
                                Icons.image_outlined,
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                size: 80,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SeasonTitle(item: item),
            TopButtons(item: item, type: .season),
            OverviewSection(text: item.overview),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final double childAspectRatio =
                      constraints.crossAxisExtent / (constraints.crossAxisExtent / 616).ceil() / 101;
                  return SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 600,
                      childAspectRatio: childAspectRatio,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: item.episodes.length,
                    itemBuilder: (context, index) {
                      final TVEpisode episode = item.episodes[index];
                      return EpisodeCard(item: episode, size: const Size(178, 100));
                    },
                  );
                },
              ),
            ),
            CastSection(type: MediaType.season, cast: item.mediaCast),
            CrewSection(type: MediaType.season, crew: item.mediaCrew),
            const SliverSafeArea(top: false, sliver: SliverToBoxAdapter()),
          ],
        );
      },
    );
  }
}
