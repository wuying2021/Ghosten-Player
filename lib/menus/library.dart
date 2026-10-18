import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import '../utils/utils.dart';
import 'abstract.dart';

class LibraryMenu extends Menu {
  const LibraryMenu(this.item);

  final Library item;

  @override
  List<Widget> build(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.sync),
        title: Text(AppLocalizations.of(context)!.buttonSyncLibrary),
        onTap: () => showNotification(
          context,
          Api.libraryRefreshById(item.id, switch (Localizations.localeOf(context).toLanguageTag()) {
            'zh' => SupportedLanguages.zhCn,
            'en' => SupportedLanguages.enUs,
            _ => SupportedLanguages.auto,
          }),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.delete_outline_rounded),
        title: Text(AppLocalizations.of(context)!.buttonDelete),
        onTap: () async {
          final bool? confirmed = await showConfirm(
            context,
            AppLocalizations.of(context)!.deleteConfirmText,
            AppLocalizations.of(context)!.deleteMediaGroupConfirmText,
          );
          if (confirmed == true && context.mounted) {
            await showNotification(context, Api.libraryDeleteById(item.id));
          }
        },
      ),
    ];
  }
}
