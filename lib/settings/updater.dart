import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../adaptive/adaptive.dart' hide Scrollbar;
import '../components/error_message.dart';
import '../components/keyboard_scroll.dart';
import '../components/markdown_viewer.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_config.dart';
import '../utils/check_update.dart';
import '../utils/utils.dart';

class SettingsUpdater extends StatefulWidget {
  const SettingsUpdater({super.key});

  @override
  State<SettingsUpdater> createState() => _SettingsUpdaterState();
}

class _SettingsUpdaterState extends State<SettingsUpdater> {
  static final Map<String, _DownloadTask> _downloading = {};
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUpdate(context.read<UserConfig>().updatePrerelease),
      builder: (context, snapshot) {
        late final Widget? section1;
        Widget? section2;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            section1 = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Text(AppLocalizations.of(context)!.checkingUpdates, style: Theme.of(context).textTheme.displaySmall),
                const LinearProgressIndicator(),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(AppLocalizations.of(context)!.checkForUpdates),
                ),
              ],
            );
          case ConnectionState.none:
          case ConnectionState.done:
            if (snapshot.hasData) {
              section1 = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.latestVersion(snapshot.requireData!.version),
                        style: Theme.of(context).textTheme.displaySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        snapshot.requireData!.createAt?.format() ?? '',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  if (_downloading.containsKey(snapshot.requireData!.url))
                    ListenableBuilder(
                      listenable: _downloading[snapshot.requireData!.url]!.progress,
                      builder: (context, _) =>
                          LinearProgressIndicator(value: _downloading[snapshot.requireData!.url]!.progress.value),
                    )
                  else
                    const LinearProgressIndicator(value: 1, color: Colors.greenAccent),
                  ElevatedButton(
                    onPressed: _downloading.containsKey(snapshot.requireData!.url)
                        ? null
                        : () => _download(snapshot.requireData!.url),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      _downloading.containsKey(snapshot.requireData!.url)
                          ? AppLocalizations.of(context)!.updating
                          : AppLocalizations.of(context)!.updateNow,
                    ),
                  ),
                ],
              );
              section2 = SliverToBoxAdapter(
                child: MarkdownViewer(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 60),
                  data: snapshot.requireData!.comment,
                  // autoScrollController: _controller,
                ),
              );
            } else if (snapshot.hasError) {
              section1 = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Text(AppLocalizations.of(context)!.updateFailed, style: Theme.of(context).textTheme.displaySmall),
                  const LinearProgressIndicator(value: 1, color: Colors.redAccent),
                  ElevatedButton(
                    autofocus: true,
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(AppLocalizations.of(context)!.checkForUpdates),
                  ),
                ],
              );
              section2 = SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                sliver: SliverToBoxAdapter(child: ErrorMessage(error: snapshot.error)),
              );
            } else {
              section1 = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Text(AppLocalizations.of(context)!.isLatestVersion, style: Theme.of(context).textTheme.displaySmall),
                  LinearProgressIndicator(value: 1, color: Theme.of(context).colorScheme.surfaceContainer),
                  Text(
                    AppLocalizations.of(context)!.lastCheckedUpdatesTime(DateTime.now().formatFullWithoutSec()),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  ElevatedButton(
                    autofocus: true,
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(AppLocalizations.of(context)!.checkForUpdates),
                  ),
                ],
              );
            }
        }
        return OrientationPage(
          section1: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(padding: const EdgeInsets.only(bottom: 64), child: section1),
              ),
            ),
          ),
          section2: section2,
        );
      },
    );
  }

  Future<void> _download(String url) async {
    final String proxy = context.read<UserConfig>().githubProxy;
    await FilePicker.requestStoragePermission();
    final task = _DownloadTask(url);
    setState(() {
      _downloading[url] = task;
      _failed = false;
    });
    final cachePath = '${(await FilePicker.cachePath)!}/$appName-${DateTime.now().millisecondsSinceEpoch}.apk';
    await Dio()
        .download(
          '$proxy$url',
          cachePath,
          onReceiveProgress: (count, total) {
            if (total <= 0) {
              return;
            }
            if (mounted) {
              task.progress.value = count / total;
            }
          },
        )
        .catchError((error) {
          if (mounted) {
            setState(() {
              _downloading.remove(url);
              task.dispose();
              _failed = true;
            });
          }
          throw error;
        }, test: (e) => true);
    if (mounted) {
      setState(() {
        _downloading.remove(url);
        task.dispose();
      });
    }
    await InstallPlugin.install(cachePath);
  }
}

class _SettingsUpdating extends StatefulWidget {
  const _SettingsUpdating({required this.data});

  final UpdateData data;

  @override
  State<_SettingsUpdating> createState() => _SettingsUpdatingState();
}

class _SettingsUpdatingState extends State<_SettingsUpdating> {
  static final Map<String, _DownloadTask> _downloading = {};
  final _controller = AutoScrollController();

  // ignore: unused_field
  bool _failed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Align(
            alignment: const Alignment(0, -0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.latestVersion(widget.data.version),
                      style: Theme.of(context).textTheme.displaySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(widget.data.createAt?.format() ?? '', style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
                const SizedBox(height: 12),
                if (_downloading.containsKey(widget.data.url))
                  ListenableBuilder(
                    listenable: _downloading[widget.data.url]!.progress,
                    builder: (context, _) =>
                        LinearProgressIndicator(value: _downloading[widget.data.url]!.progress.value),
                  )
                else
                  const LinearProgressIndicator(value: 1, color: Colors.greenAccent),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeyboardScroll(
                  autofocus: true,
                  controller: _controller,
                  child: Scrollbar(
                    controller: _controller,
                    child: MarkdownViewer(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 60),
                      data: widget.data.comment,
                      autoScrollController: _controller,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 32, right: 60),
                child: ElevatedButton(
                  onPressed: _downloading.containsKey(widget.data.url) ? null : _download,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    _downloading.containsKey(widget.data.url)
                        ? AppLocalizations.of(context)!.updating
                        : AppLocalizations.of(context)!.updateNow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _download() async {
    final String proxy = context.read<UserConfig>().githubProxy;
    await FilePicker.requestStoragePermission();
    final String url = widget.data.url;
    final task = _DownloadTask(url);
    setState(() {
      _downloading[url] = task;
      _failed = false;
    });
    final cachePath = '${(await FilePicker.cachePath)!}/$appName-${DateTime.now().millisecondsSinceEpoch}.apk';
    await Dio()
        .download(
          '$proxy$url',
          cachePath,
          onReceiveProgress: (count, total) {
            if (total <= 0) {
              return;
            }
            if (mounted) {
              task.progress.value = count / total;
            }
          },
        )
        .catchError((error) {
          if (mounted) {
            setState(() {
              _downloading.remove(url);
              task.dispose();
              _failed = true;
            });
          }
          throw error;
        }, test: (e) => true);
    if (mounted) {
      setState(() {
        _downloading.remove(url);
        task.dispose();
      });
    }
    await InstallPlugin.install(cachePath);
  }
}

class _DownloadTask {
  _DownloadTask(this.url);

  final String url;
  final ValueNotifier<double?> progress = ValueNotifier(null);

  void dispose() {
    progress.dispose();
  }
}
