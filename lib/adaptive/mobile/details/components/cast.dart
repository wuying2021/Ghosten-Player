import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../../../cards/cards.dart';
import '../../../../components/components.dart';
import '../../../../extensions/extensions.dart';
import '../../../../l10n/app_localizations.dart';

class CastSection extends StatelessWidget {
  const CastSection({super.key, required this.cast, required this.type});

  final List<MediaCast> cast;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return SliverHorizontalList(
      header: Text(AppLocalizations.of(context)!.titleCasts),
      cardStyle: theme.castCardTheme,
      itemCount: cast.length,
      itemBuilder: (context, index, size) => CastCard(item: cast[index], size: size),
    );
  }
}
