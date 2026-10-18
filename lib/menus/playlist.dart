import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import '../utils/utils.dart';
import 'abstract.dart';

class PlaylistMenu extends Menu {
  const PlaylistMenu(this.item);

  final Playlist item;

  @override
  List<Widget> build(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.sync),
        title: Text(AppLocalizations.of(context)!.buttonRefresh),
        onTap: () => showNotification(context, Api.playlistRefreshById(item.id)),
      ),
      ListTile(
        leading: const Icon(Icons.edit),
        onTap: () => context.pushNamed(.liveEdit, arguments: item),
        title: Text(AppLocalizations.of(context)!.buttonEdit),
      ),
      ListTile(
        leading: const Icon(Icons.delete_outline_rounded),
        title: Text(AppLocalizations.of(context)!.buttonDelete),
        onTap: () async {
          final bool? confirm = await showConfirm(
            context,
            AppLocalizations.of(context)!.deleteConfirmText,
            AppLocalizations.of(context)!.deletePlaylistTip,
          );
          if (confirm == true && context.mounted) {
            await showNotification(context, Api.playlistDeleteById(item.id));
          }
        },
      ),
    ];
  }
}
