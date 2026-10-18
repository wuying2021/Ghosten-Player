import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:rxdart/rxdart.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../menus/library.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';

class SettingsLibraryPage extends StatefulWidget {
  const SettingsLibraryPage({super.key, required this.type});

  final LibraryType type;

  @override
  State<SettingsLibraryPage> createState() => _SettingsLibraryPageState();
}

class _SettingsLibraryPageState extends State<SettingsLibraryPage> {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([
      EventDispatcher.where(type: .library, subType: .add),
      EventDispatcher.where(type: .library, subType: .delete),
    ]).listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingPage(
      title: Text(switch (widget.type) {
        LibraryType.tv => AppLocalizations.of(context)!.settingsItemTV,
        LibraryType.movie => AppLocalizations.of(context)!.settingsItemMovie,
      }),
      actions: [
        IconButton(
          onPressed: () async {
            final (int, DriverFile)? res = await showDriverFilePicker(context, switch (widget.type) {
              LibraryType.tv => AppLocalizations.of(context)!.pageTitleCreateTVLibrary,
              LibraryType.movie => AppLocalizations.of(context)!.pageTitleCreateMovieLibrary,
            }, selectableType: FileType.folder);
            if (res != null && context.mounted) {
              await _addLibrary(context, res.$1, res.$2);
            }
          },
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      child: FutureBuilderHandler<List<Library>>(
        future: Api.libraryQueryAll(widget.type),
        builder: (context, snapshot) => snapshot.requireData.isNotEmpty
            ? ListView.builder(
                padding: SettingPageTheme.of(context).contentPadding,
                itemCount: snapshot.requireData.length,
                itemBuilder: (context, index) {
                  final Library item = snapshot.requireData[index];
                  return ActionListTile(
                    autofocus: index == 0,
                    title: Text(item.filename),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: item.poster == null
                            ? Ink(
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                ),
                                child: const Icon(Icons.image_outlined, size: 24),
                              )
                            : AsyncImage(item.poster!, radius: BorderRadius.circular(6), ink: true),
                      ),
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(AppLocalizations.of(context)!.driverType(item.driverType.name)),
                        Text(item.driverName, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    actions: LibraryMenu(item),
                  );
                },
              )
            : const NoData(),
      ),
    );
  }

  Future<void> _addLibrary(BuildContext context, int driverId, DriverFile file) async {
    final SupportedLanguages language = switch (Localizations.localeOf(context).toLanguageTag()) {
      'zh' => SupportedLanguages.zhCn,
      'en' => SupportedLanguages.enUs,
      _ => SupportedLanguages.auto,
    };
    await showNotification<bool>(
      context,
      Future(() async {
        final dynamic id = await Api.libraryInsert(
          type: widget.type,
          driverId: driverId,
          id: file.id,
          parentId: file.parentId,
          filename: file.name,
        );
        await Api.libraryRefreshById(id, language);
        return true;
      }),
    );
  }
}
