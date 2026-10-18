import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../components/components.dart';
import '../../../menus/series.dart';
import '../../../previews/previews.dart';
import 'components/components.dart';
import 'titles/series.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key, this.data, required this.id});

  final dynamic id;
  final TVSeries? data;

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([
      EventDispatcher.where(type: .series, subType: .update, id: widget.id).doOnData((_) => setState(() {})),
      EventDispatcher.where(
        type: .series,
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
  Widget build(BuildContext context) {
    return FilledButtonTheme(
      data: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          textStyle: Theme.of(context).textTheme.labelSmall,
          tapTargetSize: .shrinkWrap,
        ),
      ),
      child: FutureBuilderHandler(
        initialData: widget.data,
        future: Api.tvSeriesQueryById(widget.id),
        errorBuilder: (context, snapshot) => Scaffold(
          body: Center(child: ErrorMessage(error: snapshot.error)),
        ),
        builder: (context, snapshot) {
          final TVSeries item = snapshot.requireData;
          return DetailScaffold(
            onRefresh: () async => setState(() {}),
            themeColor: item.themeColor,
            image: item.backdrop != null ? AsyncImage(item.backdrop!) : null,
            menus: SeriesMenu(item),
            slivers: [
              LogoSection(logo: item.logo),
              TopButtons(item: item, type: .series),
              SeriesTitle(item: item),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              OverviewSection(text: item.overview, poster: item.poster, trimLines: 8),
              NextToPlaySection(item: item.nextToPlay),
              StudiosSection(type: MediaType.series, studios: item.studios),
              GenresSection(type: MediaType.series, genres: item.genres),
              KeywordsSection(type: MediaType.series, keywords: item.keywords),
              SeasonsSection(seasons: item.seasons),
              CastSection(type: MediaType.series, cast: item.mediaCast),
              CrewSection(type: MediaType.series, crew: item.mediaCrew),
              const SliverSafeArea(top: false, sliver: SliverToBoxAdapter()),
            ],
          );
        },
      ),
    );
  }
}

@AppPreview(group: 'Series Page (Mobile)', name: 'Normal', size: Size(400, 800))
Widget seriesPagePreview() {
  return const SeriesPage(id: 12);
}
