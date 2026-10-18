import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../components/components.dart';
import '../../../menus/episode.dart';
import 'components/components.dart';
import 'titles/episode.dart';

class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key, required this.id, this.data});

  final dynamic id;
  final TVEpisode? data;

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([
      EventDispatcher.where(type: .episode, subType: .update, id: widget.id).doOnData((_) => setState(() {})),
      EventDispatcher.where(
        type: .episode,
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
    return FutureBuilderHandler(
      initialData: widget.data,
      future: Api.tvEpisodeQueryById(widget.id),
      errorBuilder: (context, snapshot) => Scaffold(
        body: Center(child: ErrorMessage(error: snapshot.error)),
      ),
      builder: (context, snapshot) {
        final TVEpisode item = snapshot.requireData;
        return DetailScaffold(
          onRefresh: () async => setState(() {}),
          themeColor: item.themeColor,
          imageAspectRatio: 16 / 10,
          menus: EpisodeMenu(item),
          slivers: [
            SliverSafeArea(
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
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
            ),
            EpisodeTitle(item: item),
            TopButtons(item: item, type: .episode),
            OverviewSection(text: item.overview),
            CastSection(type: MediaType.movie, cast: item.mediaCast),
            CastSection(type: MediaType.movie, cast: item.guestStars),
            CrewSection(type: MediaType.movie, crew: item.mediaCrew),
            if (item.fileId != null) FileInfoSection(fileId: item.fileId!),
          ],
        );
      },
    );
  }
}
