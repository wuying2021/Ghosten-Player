import 'package:api/api.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide ListTile, SwitchListTile;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/player.dart';

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'setting_page.dart';

class PlayerSettings extends StatelessWidget {
  const PlayerSettings({
    super.key,
    required this.controller,
    required this.onSeekSpeedChanged,
    required this.onShowLiteProgressbarChanged,
    required this.prefs,
  });

  final SharedPreferences prefs;
  final PlayerController controller;
  final ValueChanged<int> onSeekSpeedChanged;
  final ValueChanged<bool> onShowLiteProgressbarChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return SettingPage.list(
      title: Text(localizations.settingsTitle),
      children: [
        ValueListenableBuilder(
          valueListenable: controller.trackGroup,
          builder: (context, value, _) => _buildTrackSelector(
            context,
            icon: const Icon(Icons.movie_outlined),
            label: localizations.videoSettingsVideo,
            tracks: value.video,
            selected: value.selectedVideo,
            onSelected: (id) => controller.setTrack('video', id),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller.trackGroup,
          builder: (context, value, _) => _buildTrackSelector(
            context,
            icon: const Icon(Icons.audiotrack_outlined),
            label: localizations.videoSettingsAudio,
            tracks: value.audio,
            selected: value.selectedAudio,
            onSelected: (id) => controller.setTrack('audio', id),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller.trackGroup,
          builder: (context, value, _) => _buildTrackSelector(
            context,
            icon: const Icon(Icons.subtitles_outlined),
            label: localizations.videoSettingsSubtitle,
            tracks: value.sub,
            selected: value.selectedSub,
            onSelected: (id) => controller.setTrack('sub', id),
          ),
        ),
        ListenableBuilder(
          listenable: controller.playbackSpeed,
          builder: (context, _) => MenuListTile(
            leading: const Icon(Icons.slow_motion_video_rounded),
            title: Text(localizations.videoSettingsSpeeding),
            trailing: Text('${controller.playbackSpeed.value}x'),
            initialValue: controller.playbackSpeed.value,
            onSelected: controller.setPlaybackSpeed,
            itemBuilder: (BuildContext context) => playerSpeedList
                .map(
                  (playerSpeed) => CheckedPopupMenuItem(
                    checked: controller.playbackSpeed.value == playerSpeed.value,
                    value: playerSpeed.value,
                    child: Text(playerSpeed.text),
                  ),
                )
                .toList(),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller.trackGroup,
          builder: (context, value, _) =>
              (value.video.isEmpty && value.audio.isEmpty && value.sub.isEmpty) ? const SizedBox() : const Divider(),
        ),
        ValueListenableBuilder(
          valueListenable: controller.aspectRatio,
          builder: (context, value, _) => MenuListTile(
            leading: const Icon(Icons.aspect_ratio_rounded),
            title: Text(localizations.videoAspectRatio),
            initialValue: value,
            trailing: Text(value.label()),
            itemBuilder: (context) => AspectRatioType.values
                .map(
                  (aspectRatio) => CheckedPopupMenuItem(
                    checked: aspectRatio == controller.aspectRatio.value,
                    value: aspectRatio,
                    child: Text(aspectRatio.label()),
                  ),
                )
                .toList(),
            onSelected: (aspectRatio) {
              controller.aspectRatio.value = aspectRatio;
              controller.resizeMode.value = ResizeMode.fit;
              controller.setAspectRatio(aspectRatio.value());
              controller.setResizeMode(ResizeMode.values.indexOf(ResizeMode.fit));
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller.resizeMode,
          builder: (context, value, _) => MenuListTile(
            leading: const Icon(Icons.zoom_out_map_rounded),
            title: Text(localizations.videoResizeMode),
            trailing: Text(value.label()),
            initialValue: value,
            itemBuilder: (context) => ResizeMode.values
                .map(
                  (resizeMode) => CheckedPopupMenuItem(
                    checked: resizeMode == value,
                    value: resizeMode,
                    child: Text(resizeMode.label()),
                  ),
                )
                .toList(),
            onSelected: (resizeMode) {
              controller.resizeMode.value = resizeMode;
              controller.aspectRatio.value = AspectRatioType.auto;
              controller.setAspectRatio(AspectRatioType.auto.value());
              controller.setResizeMode(ResizeMode.values.indexOf(resizeMode));
            },
          ),
        ),
        ListTile(
          title: Text(localizations.subtitleSetting),
          leading: const Icon(Icons.subtitles_outlined),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () async {
            final initialStyle = SubtitleSettings.fromJson(PlayerConfig.getSubtitleSettings(prefs));
            if (!context.mounted) {
              return;
            }

            final List<int>? style = await Navigator.of(context)
                .push(FadeInPageRoute(builder: (context) => PlayerSubtitleSetting(subtitleSettings: initialStyle)));
            if (style != null) {
              PlayerConfig.setSubtitleSettings(prefs, style);
              await controller.setSubtitleStyle(style);
            }
          },
        ),
        const Divider(),
        StatefulBuilder(
          builder: (context, setState) {
            final int data = PlayerConfig.getExtensionRendererMode(prefs);
            return MenuListTile(
              title: Text(localizations.extensionRendererModeLabel),
              trailing: Text(
                localizations.extensionRendererMode(data.toString()),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
              itemBuilder: (context) => [0, 1, 2]
                  .map(
                    (i) => CheckedPopupMenuItem(
                      value: i,
                      checked: data == i,
                      child: Text(localizations.extensionRendererMode(i.toString())),
                    ),
                  )
                  .toList(),
              onSelected: (value) async {
                PlayerConfig.setExtensionRendererMode(prefs, value);
                await PlayerController.setPlayerOption('extensionRendererMode', value);
              },
            );
          },
        ),
        StatefulBuilder(
          builder: (context, setState) => SwitchListTile(
            title: Text(localizations.playerEnableDecoderFallback),
            value: PlayerConfig.getEnableDecoderFallback(prefs),
            onChanged: (value) async {
              PlayerConfig.setEnableDecoderFallback(prefs, value);
              await PlayerController.setPlayerOption('enableDecoderFallback', value);
              setState(() {});
            },
          ),
        ),
        StatefulBuilder(
          builder: (context, setState) => SwitchListTile(
            title: Text(localizations.playerShowLiteProgressbar),
            value: prefs.getBool('playerConfig.showLiteProgressbar') ?? false,
            onChanged: (value) async {
              setState(() {
                prefs.setBool('playerConfig.showLiteProgressbar', value);
              });
              onShowLiteProgressbarChanged(value);
            },
          ),
        ),
        const Divider(),
        StatefulBuilder(
          builder: (context, setState) => ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.playerFastForwardSpeed),
                Text('${prefs.getInt('playerConfig.fastForwardSpeed') ?? 30} ${AppLocalizations.of(context)!.second}'),
              ],
            ),
            subtitle: Slider(
              value: prefs.getInt('playerConfig.fastForwardSpeed')?.toDouble() ?? 30,
              min: 5,
              max: 100,
              divisions: 19,
              label: (prefs.getInt('playerConfig.fastForwardSpeed') ?? 30).toString(),
              onChanged: (double value) {
                setState(() {
                  prefs.setInt('playerConfig.fastForwardSpeed', value.round());
                });
                onSeekSpeedChanged(value.round());
              },
            ),
          ),
        ),
        const Divider(),
        ValueListenableBuilder(
          valueListenable: controller.index,
          builder: (context, value, _) {
            final PlaylistItem? item = controller.currentItem;
            return item?.canSkipIntro ?? false
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.buttonSkipFromStart),
                    onTap: () async {
                      if (item?.source is TVEpisode) {
                        final TVEpisode episode = await Api.tvEpisodeQueryById((item!.source as TVEpisode).id);
                        if (context.mounted) {
                          final Duration? time = await context.pushNamed<Duration>(
                            .setSkipTime,
                            arguments: SetSkipTimeData(
                              skipTimeType: SkipTimeType.intro,
                              value: controller.position.value,
                              mediaType: MediaType.season,
                              id: episode.seasonId,
                            ),
                          );
                          if (time != null) {
                            controller.setSkipPosition(SkipTimeType.intro.name, time);
                          }
                        }
                      }
                    },
                  )
                : const SizedBox();
          },
        ),
        ValueListenableBuilder(
          valueListenable: controller.index,
          builder: (context, value, _) {
            final PlaylistItem? item = controller.currentItem;
            return item?.canSkipIntro ?? false
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.buttonSkipFromEnd),
                    onTap: () async {
                      if (item?.source is TVEpisode) {
                        final TVEpisode episode = await Api.tvEpisodeQueryById((item!.source as TVEpisode).id);
                        if (context.mounted) {
                          final Duration? time = await context.pushNamed<Duration>(
                            .setSkipTime,
                            arguments: SetSkipTimeData(
                              skipTimeType: SkipTimeType.ending,
                              value: controller.position.value,
                              mediaType: MediaType.season,
                              id: episode.seasonId,
                            ),
                          );
                          if (time != null) {
                            controller.setSkipPosition(SkipTimeType.ending.name, time);
                          }
                        }
                      }
                    },
                  )
                : const SizedBox();
          },
        ),
        ValueListenableBuilder(
          valueListenable: controller.index,
          builder: (context, value, _) {
            final PlaylistItem? item = controller.currentItem;
            return item?.downloadable ?? false
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.buttonDownload),
                    onTap: () async {
                      if (item?.source is TVEpisode) {
                        await showNotification(
                          context,
                          Api.downloadTaskCreate(
                            (item!.source as TVEpisode).fileId,
                            FilePicker.requestStoragePermission(),
                          ),
                          successText: AppLocalizations.of(context)!.tipsForDownload,
                        );
                      } else if (item?.source is Movie) {
                        await showNotification(
                          context,
                          Api.downloadTaskCreate((item!.source as Movie).fileId, FilePicker.requestStoragePermission()),
                          successText: AppLocalizations.of(context)!.tipsForDownload,
                        );
                      }
                    },
                  )
                : const SizedBox();
          },
        ),
        ValueListenableBuilder(
          valueListenable: controller.index,
          builder: (context, value, _) {
            final PlaylistItem? item = controller.currentItem;
            return item != null && (item.canSkipIntro || item.canSkipEnding || item.downloadable)
                ? const Divider()
                : const SizedBox();
          },
        ),
        ValueListenableBuilder(
          valueListenable: controller.mediaInfo,
          builder: (context, value, _) => value != null
              ? DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodySmall!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Table(
                      columnWidths: const <int, TableColumnWidth>{0: FixedColumnWidth(60), 1: FlexColumnWidth()},
                      children: [
                        TableRow(
                          children: [
                            Text('Video', style: Theme.of(context).textTheme.titleSmall),
                            Container(),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Codecs'),
                            Text(controller.mediaInfo.value!.videoCodecs ?? localizations.tagUnknown),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Mime'),
                            Text(controller.mediaInfo.value!.videoMime ?? localizations.tagUnknown),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('FPS'),
                            Text(controller.mediaInfo.value!.videoFPS?.toString() ?? localizations.tagUnknown),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Size'),
                            Text(controller.mediaInfo.value!.videoSize ?? localizations.tagUnknown),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Audio', style: Theme.of(context).textTheme.titleSmall),
                            ),
                            Container(),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Codecs'),
                            Text(controller.mediaInfo.value!.audioCodecs ?? localizations.tagUnknown),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Mime'),
                            Text(controller.mediaInfo.value!.audioMime ?? localizations.tagUnknown),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Bitrate'),
                            Text(controller.mediaInfo.value!.audioBitrate?.toString() ?? localizations.tagUnknown),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        const Focus(child: SizedBox()),
      ],
    );
  }

  Widget _buildTrackSelector(
    BuildContext context, {
    required Widget icon,
    required String label,
    required List<MediaTrack> tracks,
    dynamic selected,
    required Function(dynamic) onSelected,
  }) {
    if (tracks.isEmpty) {
      return const SizedBox();
    }
    final MediaTrack? selectedTrack = tracks.firstWhereOrNull((v) => v.id == selected);
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return MenuListTile(
      leading: icon,
      title: Text(label),
      initialValue: selected,
      trailing: Text(selectedTrack?.name ?? localizations.none, overflow: TextOverflow.ellipsis),
      itemBuilder: (context) => [
        CheckedPopupMenuItem(checked: selected == null, child: Text(localizations.none)),
        ...tracks.map(
          (e) => CheckedPopupMenuItem<String?>(checked: e.id == selected, value: e.id, child: Text(_getTrackText(e))),
        ),
      ],
      onSelected: onSelected,
    );
  }

  String _getTrackText(MediaTrack track) {
    final List<dynamic> spans = [];
    if (track.name?.isNotEmpty ?? false) {
      spans.add(track.name);
    }
    if (track.label?.isNotEmpty ?? false) {
      spans.add(track.label);
    }
    if (track.mimeType?.isNotEmpty ?? false) {
      final List<String> mimes = track.mimeType!.split('/');
      if (mimes.length >= 2) {
        spans.add(mimes[1]);
      }
    }
    if (track.rate != null && track.rate! > 0) {
      spans.add('${track.rate}Hz');
    }
    if (track.averageBitrate != null && track.averageBitrate! > 0) {
      spans.add('${track.rate}Bit/s');
    }
    return spans.join(', ');
  }
}

extension on PlaylistItem {
  bool get downloadable {
    if (source is Movie) {
      return !(source as Movie).downloaded;
    } else if (source is TVEpisode) {
      return !(source as TVEpisode).downloaded;
    } else {
      return false;
    }
  }

  bool get canSkipIntro {
    return source is TVEpisode;
  }

  bool get canSkipEnding {
    return source is TVEpisode;
  }
}
