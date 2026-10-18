import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../cards/cards.dart';
import '../../../../components/components.dart';
import '../../../../extensions/extensions.dart';
import '../../../../l10n/app_localizations.dart';

class SeasonsSection extends StatelessWidget {
  const SeasonsSection({super.key, required this.seasons});

  final List<TVSeason> seasons;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return SliverHorizontalList(
      header: Text(AppLocalizations.of(context)!.titleSeasons),
      cardStyle: theme.seasonCardTheme,
      itemCount: seasons.length,
      itemBuilder: (context, index, size) => SeasonCard(item: seasons[index], size: size),
    );
  }
}
