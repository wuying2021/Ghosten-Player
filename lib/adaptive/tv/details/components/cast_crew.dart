import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../cards/series_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../utils/utils.dart';
import '../../components/image_card.dart';

class CastCrewInner extends StatelessWidget {
  const CastCrewInner({super.key, required this.mediaCast, required this.mediaCrew, required this.type});

  final List<MediaCast> mediaCast;
  final List<MediaCrew> mediaCrew;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return SliverCrossAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(right: 8),
          sliver: SliverFixedExtentList.builder(
            itemCount: mediaCast.length,
            itemExtent: 176,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _CastListTile(
                item: mediaCast[index],
                autofocus: index == 0,
                onTap: () => context.pushNamed(
                  .media,
                  arguments: MediaListData(
                    type: .series,
                    query: MediaSearchQuery(mediaCast: [mediaCast[index].id]),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 8),
          sliver: SliverFixedExtentList.builder(
            itemCount: mediaCrew.length,
            itemExtent: 176,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _CrewListTile(
                item: mediaCrew[index],
                onTap: () => context.pushNamed(
                  .media,
                  arguments: {
                    'onQuery': (int i) =>
                        Api.tvSeriesQueryAll(MediaSearchQuery(limit: 30, offset: 30 * i, mediaCrew: [mediaCrew[i].id])),
                    'itemBuilder': (context, item, index) => SeriesCard(item: item),
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CastCrewTitle extends StatelessWidget {
  const CastCrewTitle({super.key, required this.mediaCast, required this.mediaCrew});

  final List<MediaCast> mediaCast;
  final List<MediaCrew> mediaCrew;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      child: SliverCrossAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: mediaCast.isNotEmpty ? Text(AppLocalizations.of(context)!.titleCasts) : null,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: mediaCrew.isNotEmpty ? Text(AppLocalizations.of(context)!.titleCrews) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class CastCrewSection extends StatelessWidget {
  const CastCrewSection({super.key, required this.mediaCast, required this.mediaCrew, required this.type});

  final List<MediaCast> mediaCast;
  final List<MediaCrew> mediaCrew;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        CastCrewTitle(mediaCast: mediaCast, mediaCrew: mediaCrew),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: CastCrewInner(mediaCast: mediaCast, mediaCrew: mediaCrew, type: type),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _CastListTile extends StatelessWidget {
  const _CastListTile({required this.item, this.autofocus = false, this.onTap});

  final MediaCast item;
  final bool autofocus;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ImageCard(
      width: 107,
      height: 160,
      src: item.profile,
      placeholder: Icon(item.gender == 1 ? Icons.person_2_rounded : Icons.person_rounded, size: 50),
      direction: .horizontal,
      onTap: onTap,
      title: Text(item.name, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          if (item.role != null)
            Text('${AppLocalizations.of(context)!.actAs} ${item.role}', style: Theme.of(context).textTheme.bodySmall),
          Text(AppLocalizations.of(context)!.gender(item.gender.toString())),
          if (item.episodeCount != null && item.episodeCount! > 0) Text('${item.episodeCount}集'),
          if (item.scraper.type == ScraperType.tmdb) const _IMDBTag() else const _NfoTag(),
        ],
      ),
    );
  }
}

class _CrewListTile extends StatelessWidget {
  const _CrewListTile({required this.item, this.onTap});

  final MediaCrew item;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ImageCard(
      width: 107,
      height: 160,
      src: item.profile,
      placeholder: Icon(item.gender == 1 ? Icons.person_2_rounded : Icons.person_rounded, size: 50),
      direction: .horizontal,
      onTap: onTap,
      title: Text(item.name, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          if (item.department != null) Text(item.department!, style: Theme.of(context).textTheme.bodySmall),
          if (item.job != null) Text(item.job!, style: Theme.of(context).textTheme.bodySmall),
          Text(AppLocalizations.of(context)!.gender(item.gender.toString())),
          if (item.episodeCount != null && item.episodeCount! > 0) Text('${item.episodeCount}集'),
          if (item.scraper.type == ScraperType.tmdb) const _IMDBTag() else const _NfoTag(),
        ],
      ),
    );
  }
}

class _IMDBTag extends StatelessWidget {
  const _IMDBTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff86caa5)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(2),
      child: const Text('TMDB', style: TextStyle(fontSize: 8, color: Color(0xff86caa5))),
    );
  }
}

class _NfoTag extends StatelessWidget {
  const _NfoTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff86caa5)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(2),
      child: const Text('NFO', style: TextStyle(fontSize: 8, color: Color(0xff86caa5))),
    );
  }
}
