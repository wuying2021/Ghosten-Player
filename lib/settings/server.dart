import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:rxdart/rxdart.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../menus/server.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';

class SystemSettingsServer extends StatefulWidget {
  const SystemSettingsServer({super.key});

  @override
  State<SystemSettingsServer> createState() => _SystemSettingsServerState();
}

class _SystemSettingsServerState extends State<SystemSettingsServer> {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([
      EventDispatcher.where(type: .server, subType: .add),
      EventDispatcher.where(type: .server, subType: .update),
      EventDispatcher.where(type: .server, subType: .delete),
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
      title: Text(AppLocalizations.of(context)!.settingsItemServer),
      actions: [IconButton(onPressed: () => context.pushNamed(.settingsServerAdd), icon: const Icon(Icons.add))],
      child: FutureBuilderHandler(
        future: Api.serverQueryAll(),
        builder: (context, snapshot) => ListView.builder(
          padding: SettingPageTheme.of(context).contentPadding,
          itemBuilder: (context, index) {
            final Server item = snapshot.requireData[index];
            return ActionListTile(
              leading: IgnorePointer(
                child: RadioGroup(groupValue: item.active, onChanged: (_) {}, child: const Radio(value: true)),
              ),
              trailing: item.invalid
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.red),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    )
                  : null,
              title: Row(
                spacing: 8,
                children: [
                  Text(AppLocalizations.of(context)!.driverType(item.type.name)),
                  if (item.username != null) Text(item.username!),
                ],
              ),
              subtitle: item.host.isNotEmpty ? Text(item.host) : null,
              actions: ServerMenu(item),
            );
          },
          itemCount: snapshot.requireData.length,
        ),
      ),
    );
  }
}
