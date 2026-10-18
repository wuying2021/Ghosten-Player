import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../components/components.dart';
import '../../../menus/movie.dart';
import 'components/components.dart';
import 'titles/movie.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.id, this.data});

  final dynamic id;
  final Movie? data;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([
      EventDispatcher.where(type: .movie, subType: .update, id: widget.id).doOnData((_) => setState(() {})),
      EventDispatcher.where(type: .movie, subType: .delete, id: widget.id).doOnData((_) => Navigator.of(context).pop()),
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
        future: Api.movieQueryById(widget.id),
        errorBuilder: (context, snapshot) => Scaffold(
          body: Center(child: ErrorMessage(error: snapshot.error)),
        ),
        builder: (context, snapshot) {
          final Movie item = snapshot.requireData;
          return DetailScaffold(
            onRefresh: () async => setState(() {}),
            themeColor: item.themeColor,
            image: item.backdrop != null ? AsyncImage(item.backdrop!) : null,
            menus: MovieMenu(item),
            slivers: [
              LogoSection(logo: item.logo),
              TopButtons(item: item, type: .movie),
              MovieTitle(item: item),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              OverviewSection(text: item.overview, poster: item.poster, trimLines: 8),
              StudiosSection(type: MediaType.movie, studios: item.studios),
              GenresSection(type: MediaType.movie, genres: item.genres),
              KeywordsSection(type: MediaType.movie, keywords: item.keywords),
              CastSection(type: MediaType.movie, cast: item.mediaCast),
              CrewSection(type: MediaType.movie, crew: item.mediaCrew),
              if (item.fileId != null) FileInfoSection(fileId: item.fileId!),
            ],
          );
        },
      ),
    );
  }
}
