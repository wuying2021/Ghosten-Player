import 'package:flutter/material.dart' hide ListTile, RadioListTile, SwitchListTile;
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_config.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';

class SettingsAboutPage extends StatefulWidget {
  const SettingsAboutPage({super.key});

  @override
  State<SettingsAboutPage> createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends State<SettingsAboutPage> {
  late final UserConfig _userConfig = Provider.of<UserConfig>(context);

  @override
  Widget build(BuildContext context) {
    return SettingPage.list(
      title: Text(AppLocalizations.of(context)!.settingsItemInfo),
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.checkForUpdates),
          onTap: () => context.pushNamed(.settingsUpdater),
        ),
        MenuListTile(
          title: Text(AppLocalizations.of(context)!.autoCheckForUpdates),
          trailing: Text(AppLocalizations.of(context)!.autoUpdateFrequency(_userConfig.autoUpdateFrequency.name)),
          initialValue: _userConfig.autoUpdateFrequency,
          onSelected: (value) {
            _userConfig.setAutoUpdate(value);
            setState(() {});
          },
          itemBuilder: (BuildContext context) => AutoUpdateFrequency.values
              .map(
                (item) => CheckedPopupMenuItem(
                  value: item,
                  checked: _userConfig.autoUpdateFrequency == item,
                  child: Text(AppLocalizations.of(context)!.autoUpdateFrequency(item.name)),
                ),
              )
              .toList(),
        ),
        SwitchListTile(
          value: _userConfig.updatePrerelease,
          onChanged: (value) {
            _userConfig.setUpdatePrerelease(value);
            setState(() {});
          },
          title: Text(AppLocalizations.of(context)!.updatePrerelease),
        ),
        ListTile(
          leading: const Logo(size: 32),
          title: const Text(appName),
          subtitle: const Text(appVersion),
          trailing: const Text(buildDate),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: appName,
            applicationVersion: appVersion,
            applicationIcon: const Logo(size: 32),
          ),
        ),
      ],
    );
  }
}
