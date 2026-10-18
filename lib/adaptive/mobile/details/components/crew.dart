import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../cards/cards.dart';
import '../../../../components/components.dart';
import '../../../../extensions/extensions.dart';
import '../../../../l10n/app_localizations.dart';

class CrewSection extends StatelessWidget {
  const CrewSection({super.key, required this.crew, required this.type});

  final List<MediaCrew> crew;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return SliverHorizontalList(
      header: Text(AppLocalizations.of(context)!.titleCrews),
      cardStyle: theme.crewCardTheme,
      itemCount: crew.length,
      itemBuilder: (context, index, size) => CrewCard(item: crew[index], size: size),
    );
  }
}
