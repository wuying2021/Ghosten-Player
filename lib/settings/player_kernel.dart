import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide RadioListTile;
import 'package:flutter_archive/flutter_archive.dart';
import 'package:provider/provider.dart';
import 'package:video_player/player.dart';

import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import '../../platform_api.dart';
import '../../providers/user_config.dart';
import '../../utils/check_update.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';
import '../components/components.dart';

class SettingsPlayerKernel extends StatefulWidget {
  const SettingsPlayerKernel({super.key});

  @override
  State<SettingsPlayerKernel> createState() => _SettingsPlayerKernelState();
}

class _SettingsPlayerKernelState extends State<SettingsPlayerKernel> {
  List<_MpvLib> _localMpvLibs = [];
  List<_MpvLib>? _remoteMpvLibs;
  late final UserConfig userConfig = Provider.of<UserConfig>(context);
  static final Map<String, CancelToken> _downloadTasks = {};

  @override
  void initState() {
    super.initState();
    _getLocalMpvLibs();
  }

  @override
  Widget build(BuildContext context) {
    final String? mpvVersion = userConfig.mpvVersion;
    return SettingPage(
      title: Text(AppLocalizations.of(context)!.settingsItemPlayerKernel),
      child: RadioGroup(
        onChanged: (value) {
          if (value == .media3) {
            userConfig.setPlayerType(.media3);
            userConfig.setMpvVersion(null);
            setState(() {});
          }
        },
        groupValue: userConfig.playerType,
        child: ListView(
          padding: SettingPageTheme.of(context).contentPadding,
          children: [
            RadioListTile(
              value: PlayerType.media3,
              title: Text(AppLocalizations.of(context)!.playerType(PlayerType.media3.name)),
            ),
            RadioGroup(
              groupValue: mpvVersion,
              onChanged: _setMpvLib,
              child: ExpansionTile(
                leading: const SizedBox(width: 40, child: Radio(value: PlayerType.mpv, enabled: false)),
                childrenPadding: SettingPageTheme.of(context).contentPadding,
                title: Badge(
                  label: const Text('Alpha'),
                  offset: const Offset(-10, 4),
                  child: Text(AppLocalizations.of(context)!.playerType(PlayerType.mpv.name)),
                ),
                onExpansionChanged: (expanded) {
                  if (expanded) {
                    _getRemoteMpvLibs();
                  }
                },
                children: [
                  ..._localMpvLibs.map((lib) => _buildMpvListTile(lib, mpvVersion)),
                  if (_remoteMpvLibs == null)
                    const Padding(padding: EdgeInsets.all(8.0), child: Loading())
                  else
                    ..._remoteMpvLibs!.map((lib) => _buildMpvListTile(lib, mpvVersion)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton.filledTonal(
                        onPressed: () {
                          _remoteMpvLibs = null;
                          _getLocalMpvLibs();
                          _getRemoteMpvLibs();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMpvListTile(_MpvLib lib, String? mpvVersion) {
    final RadioListTile<String> child = RadioListTile(
      value: lib.version,
      title: Row(
        children: [
          Text(lib.version),
          const Spacer(),
          if (lib.downloaded) const Icon(Icons.download),
          if (lib.downloading)
            SizedBox.square(dimension: 16, child: CircularProgressIndicator(value: lib.downloadProgress)),
        ],
      ),
    );
    if (lib.downloaded && lib.version != mpvVersion) {
      return Dismissible(
        key: ValueKey(lib.version),
        confirmDismiss: (_) async {
          final bool confirmed = await showConfirm(context, AppLocalizations.of(context)!.deleteConfirmText) ?? false;
          if (confirmed) {
            await _deleteMpvLib(lib.version);
          }
          return confirmed;
        },
        onDismissed: (_) {
          _localMpvLibs.remove(lib);
          _remoteMpvLibs?.where((it) => it == lib).forEach((it) {
            it.downloaded = false;
          });
          setState(() {});
        },
        child: child,
      );
    } else {
      return child;
    }
  }

  Future<void> _getRemoteMpvLibs() async {
    if (_remoteMpvLibs != null) {
      return;
    }
    setState(() {});
    final String? arch = await PlatformApi.arch();
    final Response<dynamic> resp = await Dio(BaseOptions(connectTimeout: const Duration(seconds: 30))).get(libmpvUrl);
    if (!mounted) {
      return;
    }
    final List<UpdateResp> data = (resp.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(UpdateResp.fromJson)
        .toList();
    _remoteMpvLibs = data
        .map(
          (it) => _MpvLib(
            version: it.tagName,
            downloadUrl: it.assets.firstWhereOrNull((item) => item.name == '$arch.zip')?.url,
          ),
        )
        .where((it) => _localMpvLibs.firstWhereOrNull((i) => i.version == it.version) == null)
        .toList();
    setState(() {});
  }

  Future<void> _getLocalMpvLibs() async {
    final dir = Directory('${(await FilePicker.filePath)!}/mpv');
    if (!dir.existsSync()) {
      return;
    }
    final List<FileSystemEntity> subs = await dir.list().toList();
    if (!mounted) {
      return;
    }
    _localMpvLibs = subs.map((it) => _MpvLib(version: it.path.split('/').last, downloaded: true)).toList();
    setState(() {});
  }

  Future<void> _downloadMpvLib(_MpvLib lib) async {
    if (_downloadTasks.containsKey(lib.version)) {
      return;
    }
    lib.downloading = true;
    setState(() {});
    final cachedFilePath = '${(await FilePicker.cachePath)!}/${lib.version}.zip';
    final cancelToken = CancelToken();
    _downloadTasks.putIfAbsent(lib.version, () => cancelToken);
    try {
      await Dio().download(
        lib.downloadUrl!,
        cachedFilePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          if (total > 0 && mounted) {
            lib.downloadProgress = count.toDouble() / total.toDouble();
            setState(() {});
          }
        },
      );
    } catch (e) {
      _downloadTasks.remove(lib.version);
      lib.downloadProgress = null;
      lib.downloading = false;
      lib.downloaded = false;
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.downloaderLabelDownloadFailed),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 200,
          ),
        );
      }
      return;
    }
    _downloadTasks.remove(lib.version);
    final zipFile = File(cachedFilePath);
    final destinationDir = Directory('${(await FilePicker.filePath)!}/mpv/${lib.version}');
    try {
      await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir);
    } catch (e) {
      await zipFile.delete();
      lib.downloadProgress = null;
      lib.downloading = false;
      lib.downloaded = false;
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.downloaderLabelDownloadFailed),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 200,
          ),
        );
      }
      return;
    }
    if (zipFile.existsSync()) {
      await zipFile.delete();
    }
    lib.downloadProgress = null;
    lib.downloading = false;
    lib.downloaded = true;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteMpvLib(String version) async {
    final dir = Directory('${(await FilePicker.filePath)!}/mpv/$version');
    await dir.delete(recursive: true);
  }

  Future<void> _setMpvLib(String? version) async {
    final _MpvLib lib = [..._localMpvLibs, ...?_remoteMpvLibs].firstWhere((lib) => lib.version == version);
    if (!lib.downloaded) {
      await _downloadMpvLib(lib);
    }
    if (!lib.downloaded) {
      return;
    }
    userConfig.setPlayerType(PlayerType.mpv);
    userConfig.setMpvVersion(version);
    if (!mounted) {
      return;
    }
    setState(() {});
  }
}

class _MpvLib {
  _MpvLib({required this.version, this.downloadUrl, this.downloaded = false});

  final String version;
  final String? downloadUrl;
  bool downloaded;
  bool downloading = false;
  double? downloadProgress;
}
