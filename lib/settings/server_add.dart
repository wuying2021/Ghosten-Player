import 'package:api/api.dart';
import 'package:flutter/material.dart' hide TextFormField;

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../validators/validators.dart';
import '../adaptive/adaptive.dart';

class SettingsServerAddPage extends StatefulWidget {
  const SettingsServerAddPage({super.key});

  @override
  State<SettingsServerAddPage> createState() => _SettingsServerAddPageState();
}

class _SettingsServerAddPageState extends State<SettingsServerAddPage> {
  final _formKey = GlobalKey<FormState>();
  ServerType _type = ServerType.emby;
  late final _serverAddress = TextEditingController();
  late final _username = TextEditingController();
  late final _userPassword = TextEditingController();
  late final _userAgent = TextEditingController();

  @override
  void dispose() {
    _serverAddress.dispose();
    _username.dispose();
    _userPassword.dispose();
    _userAgent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(AppLocalizations.of(context)!.pageTitleAdd),
      onConfirmButtonPressed: () async {
        if (_formKey.currentState!.validate()) {
          final AsyncSnapshot<void>? resp = await showNotification(
            context,
            Api.serverInsert(
              type: _type,
              host: _serverAddress.text,
              username: _username.text,
              userPassword: _userPassword.text,
              userAgent: _userAgent.text,
            ),
          );
          if (resp?.error == null && context.mounted) {
            Navigator.of(context).pop(true);
          }
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            DropdownButtonFormField(
              initialValue: ServerType.emby,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.serverFormItemLabelServerType,
                prefixIcon: const Icon(Icons.domain),
                isDense: true,
              ),
              items: <ServerType>[.emby, .jellyfin]
                  .map(
                    (ty) => DropdownMenuItem(value: ty, child: Text(AppLocalizations.of(context)!.driverType(ty.name))),
                  )
                  .toList(),
              onChanged: (ty) => _type = ty!,
            ),
            Gap.vSM,
            TextFormField(
              controller: _serverAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.link),
                border: const UnderlineInputBorder(),
                labelText: AppLocalizations.of(context)!.serverFormItemLabelServer,
                isDense: true,
              ),
              validator: (value) => urlValidator(context, value, true),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
            Gap.vSM,
            TextFormField(
              controller: _username,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_circle_outlined),
                border: const UnderlineInputBorder(),
                labelText: AppLocalizations.of(context)!.loginFormItemLabelUsername,
                isDense: true,
              ),
              validator: (value) => requiredValidator(context, value),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
            Gap.vSM,
            TextFormField(
              controller: _userPassword,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                border: const UnderlineInputBorder(),
                labelText: AppLocalizations.of(context)!.loginFormItemLabelPwd,
                isDense: true,
              ),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
            Gap.vSM,
            TextFormField(
              controller: _userAgent,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.web_rounded),
                border: const UnderlineInputBorder(),
                labelText: AppLocalizations.of(context)!.loginFormItemLabelUserAgent,
                isDense: true,
              ),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          ],
        ),
      ),
    );
  }
}
