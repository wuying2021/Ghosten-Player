import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../menus/storage.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';

class SettingsStoragePage extends StatefulWidget {
  const SettingsStoragePage({super.key});

  @override
  State<SettingsStoragePage> createState() => _SettingsStoragePageState();
}

class _SettingsStoragePageState extends State<SettingsStoragePage> {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([
      EventDispatcher.where(type: .storage, subType: .add),
      EventDispatcher.where(type: .storage, subType: .delete),
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
      title: Text(AppLocalizations.of(context)!.pageTitleAccount),
      actions: [
        IconButton(onPressed: () => context.pushNamed(.settingsStorageAdd), icon: const Icon(Icons.add_rounded)),
      ],
      child: FutureBuilderHandler<List<DriverAccount>>(
        future: Api.storageQueryAll(),
        builder: (context, snapshot) {
          return snapshot.requireData.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.requireData.length,
                  padding: SettingPageTheme.of(context).contentPadding,
                  itemBuilder: (context, index) {
                    final DriverAccount item = snapshot.requireData[index];
                    return ActionListTile(
                      autofocus: index == 0,
                      title: Text(item.name),
                      subtitle: Text(AppLocalizations.of(context)!.driverType(item.type.name)),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: item.avatar == null
                            ? const AspectRatio(aspectRatio: 1, child: Icon(Icons.account_circle, size: 48))
                            : AsyncImage(item.avatar!, radius: BorderRadius.circular(6), ink: true),
                      ),
                      actions: StorageMenu(item),
                    );
                  },
                )
              : const NoData();
        },
      ),
    );
  }
}
