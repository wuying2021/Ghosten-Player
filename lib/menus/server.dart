import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import 'abstract.dart';

class ServerMenu extends Menu {
  const ServerMenu(this.item);

  final Server item;

  @override
  List<Widget> build(BuildContext context) {
    return [
      if (!item.active)
        ListTile(
          onTap: () => Api.serverActiveById(item.id),
          leading: const Icon(Icons.check_rounded),
          title: Text(AppLocalizations.of(context)!.buttonActivate),
        ),
      if (!item.active && item.id != 0) buildDeleteAction(context, () => Api.serverDeleteById(item.id)),
    ];
  }
}
