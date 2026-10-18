import 'package:api/api.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/components.dart';
import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import '../../validators/validators.dart';
import '../adaptive/adaptive.dart';

class SettingsStorageAddPage extends StatefulWidget {
  const SettingsStorageAddPage({super.key});

  @override
  State<SettingsStorageAddPage> createState() => _SettingsStorageAddPageState();
}

class _SettingsStorageAddPageState extends State<SettingsStorageAddPage> {
  late final FormGroupController _alipan;
  late final FormGroupController _webdav;
  late final FormGroupController _quark;

  DriverType _driverType = DriverType.webdav;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _webdav = FormGroupController([
      FormItem(
        'url',
        labelText: 'Host',
        hintText: 'http://127.0.0.1:8090',
        prefixIcon: const Icon(Icons.link),
        validator: (value) => urlValidator(context, value, true),
      ),
      FormItem(
        'username',
        labelText: AppLocalizations.of(context)!.loginFormItemLabelUsername,
        prefixIcon: const Icon(Icons.account_circle_outlined),
      ),
      FormItem(
        'password',
        labelText: AppLocalizations.of(context)!.loginFormItemLabelPwd,
        prefixIcon: const Icon(Icons.password),
        obscureText: true,
      ),
    ]);
    _quark = FormGroupController([
      FormItem(
        'cookie',
        labelText: 'Cookie',
        maxLines: 10,
        prefixIcon: const Icon(Icons.cookie_outlined),
        validator: (value) => requiredValidator(context, value),
      ),
    ]);
    _alipan = FormGroupController([
      FormItem(
        'token',
        labelText: AppLocalizations.of(context)!.accountCreateFormItemLabelRefreshToken,
        prefixIcon: const Icon(Icons.shield_outlined),
        maxLines: 5,
        validator: (value) => requiredValidator(context, value),
      ),
      FormItem(
        'url',
        labelText: AppLocalizations.of(context)!.accountCreateFormItemLabelOauthUrl,
        prefixIcon: const Icon(Icons.link),
        validator: (value) => urlValidator(context, value, true),
      ),
      FormItem(
        'username',
        labelText: AppLocalizations.of(context)!.accountCreateFormItemLabelClientId,
        helperText: AppLocalizations.of(context)!.formItemNotRequiredHelper,
        prefixIcon: const Icon(Icons.abc),
      ),
      FormItem(
        'password',
        labelText: AppLocalizations.of(context)!.accountCreateFormItemLabelClientPwd,
        helperText: AppLocalizations.of(context)!.formItemNotRequiredHelper,
        prefixIcon: const Icon(Icons.password),
      ),
    ]);
  }

  @override
  void dispose() {
    _alipan.dispose();
    _webdav.dispose();
    _quark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(AppLocalizations.of(context)!.pageTitleLogin),
      onConfirmButtonPressed: _login,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RadioGroup(
            onChanged: (value) => setState(() => _driverType = value!),
            groupValue: _driverType,
            child: Row(
              children: <DriverType>[.webdav, .quark, .alipan]
                  .map(
                    (ty) => [
                      Radio(value: ty),
                      GestureDetector(
                        onTap: () => setState(() => _driverType = ty),
                        child: Text(AppLocalizations.of(context)!.driverType(ty.name)),
                      ),
                      Gap.hSM,
                    ],
                  )
                  .flattened
                  .toList(),
            ),
          ),
        ),
      ),
      child: FormGroup(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        controller: switch (_driverType) {
          DriverType.webdav => _webdav,
          DriverType.alipan => _alipan,
          DriverType.quark => _quark,
          _ => throw UnimplementedError(),
        },
      ),
    );
  }

  Future<void> _login() async {
    final FormGroupController form = switch (_driverType) {
      DriverType.alipan => _alipan,
      DriverType.webdav => _webdav,
      DriverType.quark => _quark,
      _ => throw UnimplementedError(),
    };
    if (form.validate()) {
      final Map<String, dynamic> data = form.data;
      final bool? flag = await showDialog<bool>(
        context: context,
        builder: (context) => _buildLoginLoading(Api.storageInsert(_driverType, data.values)),
      );
      if ((flag ?? false) && mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Widget _buildLoginLoading(Stream<dynamic> stream) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.modalTitleNotification),
      content: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop &&
                (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.none ||
                    snapshot.hasData)) {
              Navigator.of(context).pop();
            }
          },
          child: Builder(
            builder: (context) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final data = snapshot.requireData as Map<String, dynamic>;
                    if (data['type'] == 'qrcode') {
                      return SizedBox(
                        width: kQrSize,
                        height: kQrSize,
                        child: QrImageView(backgroundColor: Colors.white, data: data['qrcode_data'], size: kQrSize),
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(padding: EdgeInsets.all(17), child: CircularProgressIndicator()),
                          Text(AppLocalizations.of(context)!.modalNotificationLoadingText),
                        ],
                      );
                    }
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(17), child: CircularProgressIndicator()),
                        Text(AppLocalizations.of(context)!.modalNotificationLoadingText),
                      ],
                    );
                  }
                case ConnectionState.none:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return ErrorMessage(
                      error: snapshot.error,
                      leading: const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    );
                  } else {
                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    });
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                        Gap.vMD,
                        Text(AppLocalizations.of(context)!.modalNotificationSuccessText),
                      ],
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
