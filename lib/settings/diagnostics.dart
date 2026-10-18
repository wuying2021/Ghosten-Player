import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:rxdart/rxdart.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../adaptive/adaptive.dart';

class SettingsDiagnostics extends StatelessWidget {
  const SettingsDiagnostics({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingPage(
      title: Text(AppLocalizations.of(context)!.settingsItemNetworkDiagnostics),
      child: StreamBuilderHandler(
        stream: Api.networkDiagnostics().scan<List<NetworkDiagnostics>>((acc, cur, _) => acc..add(cur), []),
        builder: (context, snapshot) {
          return ListView.builder(
            padding: SettingPageTheme.of(context).contentPadding,
            itemBuilder: (context, index) {
              if (index < snapshot.requireData.length) {
                final NetworkDiagnostics item = snapshot.requireData[index];
                return ListTile(
                  dense: true,
                  title: Text(item.domain),
                  subtitle: item.ip != null
                      ? Text(item.ip!)
                      : item.error != null
                      ? Text('${item.error!}\n${item.tip ?? ''}')
                      : null,
                  trailing: switch (item.status) {
                    NetworkDiagnosticsStatus.success => Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.green),
                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                    NetworkDiagnosticsStatus.fail => Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.red),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  },
                  onTap: () {},
                );
              } else {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.requireData.every((item) => item.status == NetworkDiagnosticsStatus.success)) {
                    return ListTile(
                      title: Text(AppLocalizations.of(context)!.networkStatus(NetworkDiagnosticsStatus.success.name)),
                    );
                  } else {
                    return ListTile(
                      title: Text(AppLocalizations.of(context)!.networkStatus(NetworkDiagnosticsStatus.fail.name)),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
            },
            itemCount: snapshot.requireData.length + 1,
          );
        },
      ),
    );
  }
}
