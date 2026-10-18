import 'dart:async';

import 'package:api/api.dart';
import 'package:bluetooth/bluetooth.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter/services.dart';

import '../adaptive/adaptive.dart';
import '../components/components.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../utils/check_update.dart';
import '../utils/utils.dart';

class SettingsSyncPage extends StatefulWidget {
  const SettingsSyncPage({super.key});

  @override
  State<SettingsSyncPage> createState() => _SettingsSyncPageState();
}

enum BluetoothState { withPermission, withoutPermission, discovering, nonAdaptor }

class _SettingsSyncPageState extends State<SettingsSyncPage> {
  final _devices = <BluetoothDevice>[];
  StreamSubscription<BluetoothDevice>? _subscription;
  BluetoothState _bluetoothState = BluetoothState.withoutPermission;
  bool _needStartServer = true;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _needStartServer = false;
    Bluetooth.close().catchError((_) {});
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      ListTile(
        title: Text(AppLocalizations.of(context)!.dataSyncActionRescanBluetoothDevices),
        leading: const Icon(Icons.sync),
        onTap: () => _startDiscovery(),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.dataSyncActionSetDiscoverable),
        leading: const Icon(Icons.remove_red_eye_outlined),
        onTap: () => Bluetooth.requestDiscoverable(const Duration(seconds: 60)),
      ),
      const Spacer(),
      ListTile(
        title: Text(AppLocalizations.of(context)!.dataSyncActionRollback),
        leading: const Icon(Icons.settings_backup_restore),
        onTap: () async {
          final bool? flag = await showConfirm(context, AppLocalizations.of(context)!.dataSyncConfirmRollback);
          if ((flag ?? false) && context.mounted) {
            await showNotification(context, Api.rollbackData());
          }
        },
      ),
    ];
    return DeviceOrientationBuilder(
      builder: (context, orientation) {
        switch (orientation) {
          case Orientation.portrait:
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.settingsItemDataSync),
                actions: [
                  if (_bluetoothState == BluetoothState.withPermission || _bluetoothState == BluetoothState.discovering)
                    EndDrawerButton(onPressed: () => context.showContextMenu(buttons)),
                ],
              ),
              body: switch (_bluetoothState) {
                BluetoothState.withPermission || BluetoothState.discovering => Column(
                  children: [
                    if (_bluetoothState == BluetoothState.discovering)
                      const LinearProgressIndicator()
                    else
                      const SizedBox(height: 4),
                    Expanded(
                      child: (_bluetoothState != BluetoothState.discovering && _devices.isEmpty)
                          ? const NoData()
                          : ListView.builder(
                              itemCount: _devices.length,
                              itemBuilder: (context, index) {
                                final BluetoothDevice device = _devices[index];
                                return ListTile(
                                  title: Text(device.name ?? AppLocalizations.of(context)!.tagUnknown),
                                  subtitle: Text(device.address),
                                  onTap: () => showProgressNotification(context, _startConnection(device)),
                                  trailing: Icon(
                                    device.isConnected
                                        ? Icons.import_export
                                        : device.bonded
                                        ? Icons.link
                                        : null,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
                BluetoothState.withoutPermission => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(AppLocalizations.of(context)!.dataSyncTipPermission),
                      ),
                      FilledButton(
                        onPressed: () => Bluetooth.openSettings(),
                        child: Text(AppLocalizations.of(context)!.dataSyncActionOpenSettings),
                      ),
                    ],
                  ),
                ),
                BluetoothState.nonAdaptor => Center(
                  child: Text(AppLocalizations.of(context)!.dataSyncTipNonBluetoothAdapter),
                ),
              },
            );
          case Orientation.landscape:
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 70,
                title: Text(AppLocalizations.of(context)!.settingsItemDataSync),
                titleTextStyle: Theme.of(context).textTheme.displaySmall,
                forceMaterialTransparency: true,
              ),
              extendBodyBehindAppBar: true,
              body: switch (_bluetoothState) {
                BluetoothState.withPermission || BluetoothState.discovering => Row(
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 36),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: buttons),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: _devices.isEmpty
                          ? _bluetoothState == BluetoothState.discovering
                                ? const Center(child: Loading())
                                : const NoData()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 36),
                              itemBuilder: (context, index) {
                                if (index < _devices.length) {
                                  final BluetoothDevice device = _devices[index];
                                  return ListTile(
                                    title: Text(device.name ?? AppLocalizations.of(context)!.tagUnknown),
                                    subtitle: Text(device.address),
                                    onTap: () => showProgressNotification(context, _startConnection(device)),
                                    trailing: Icon(
                                      device.isConnected
                                          ? Icons.import_export
                                          : device.bonded
                                          ? Icons.link
                                          : null,
                                    ),
                                  );
                                } else {
                                  return const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Loading());
                                }
                              },
                              itemCount: _bluetoothState == BluetoothState.discovering
                                  ? _devices.length + 1
                                  : _devices.length,
                            ),
                    ),
                  ],
                ),
                BluetoothState.withoutPermission => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dataSyncTipPermission,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        autofocus: true,
                        onPressed: () => Bluetooth.openSettings(),
                        child: Text(AppLocalizations.of(context)!.dataSyncActionOpenSettings),
                      ),
                    ],
                  ),
                ),
                BluetoothState.nonAdaptor => Center(
                  child: Text(
                    AppLocalizations.of(context)!.dataSyncTipNonBluetoothAdapter,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              },
            );
        }
      },
    );
  }

  Future<void> _init() async {
    try {
      if (await Bluetooth.requestPermission() && await Bluetooth.requestEnable()) {
        setState(() => _bluetoothState = BluetoothState.withPermission);
        _startServer();
        _startDiscovery();
      }
    } catch (e) {
      setState(() => _bluetoothState = BluetoothState.nonAdaptor);
    }
  }

  void _startServer() {
    Bluetooth.startServer().listen(
      (device) async {
        Bluetooth.connection().listen((resp) async {
          switch (resp.type) {
            case BlueToothMessageType.file:
              await Bluetooth.disconnect();
              if (mounted) {
                final bool? confirmed = await showConfirm(
                  context,
                  AppLocalizations.of(context)!
                      .dataSyncConfirmSync(device.name ?? AppLocalizations.of(context)!.tagUnknown),
                );
                if (confirmed ?? false) {
                  await Api.syncData(resp.data);
                }
              }
            case BlueToothMessageType.text:
              await Bluetooth.writeText(appVersion);
          }
        });
      },
      onError: (error) {
        if (mounted) {
          showNotification(context, Future.error(error));
        }
      },
      onDone: () {
        if (_needStartServer) {
          _startServer();
        }
      },
    );
  }

  void _startDiscovery() {
    setState(() {
      _devices.clear();
      _bluetoothState = BluetoothState.discovering;
    });
    if (_subscription != null) {
      _subscription!.cancel();
    }
    Bluetooth.getBondedDevices().then((value) => setState(() => _devices.addAll(value)));
    _subscription = Bluetooth.startDiscovery().listen(
      (device) {
        final int index = _devices.indexWhere((element) => element.address == device.address);
        if (index >= 0) {
          _devices[index] = device;
        } else {
          _devices.add(device);
        }
        setState(() {});
      },
      onError: (error) {},
      onDone: () {
        setState(() => _bluetoothState = BluetoothState.withPermission);
      },
    );
  }

  Stream<double> _startConnection(BluetoothDevice device) async* {
    await Bluetooth.connect(device.address);
    await Bluetooth.writeText(appVersion);
    final BluetoothMessage resp = await Bluetooth.connection().first;
    switch (resp.type) {
      case BlueToothMessageType.text:
        final remoteVersion = Version.fromString(resp.data);
        final localVersion = Version.fromString(appVersion);
        if (localVersion > remoteVersion) {
          await Bluetooth.disconnect();
          if (mounted) {
            throw PlatformException(
              message: AppLocalizations.of(context)!.dataSyncTipOutOfDate(device.name ?? ''),
              code: '',
            );
          }
        } else {
          yield* Bluetooth.writeFile((await Api.databasePath())!);
        }
      case BlueToothMessageType.file:
        if (mounted) {
          throw Exception(AppLocalizations.of(context)!.dataSyncTipSyncError);
        }
    }
  }
}
