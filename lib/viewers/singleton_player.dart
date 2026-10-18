import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/player.dart';

import '../adaptive/adaptive.dart';
import '../components/components.dart ';
import '../models/models.dart';
import '../providers/user_config.dart';
import '../utils/utils.dart';

class SingletonPlayer extends StatefulWidget {
  const SingletonPlayer({super.key, required this.data});

  final PlaylistData data;

  @override
  State<SingletonPlayer> createState() => _SingletonPlayerState();
}

class _SingletonPlayerState extends State<SingletonPlayer> {
  late final _controller = PlayerController(
    onGetPlayBackInfo: _onGetPlayBackInfo,
    onPlaybackStatusUpdate: _onPlaybackStatusUpdate,
  );

  Future<PlayerFileInfo> _onGetPlayBackInfo(PlaylistItem item) async {
    final dynamic source = _controller.currentItem!.source;
    if (source is TVEpisode) {
      final PlaybackInfo data = await Api.playbackInfo(source.fileId);
      return PlayerFileInfo(
        url: Uri.parse(data.url).normalize(),
        subtitles: data.subtitles.map((d) => d.toSubtitle()).nonNulls.toList(),
        others: data.others,
      );
    } else if (source is Movie) {
      final PlaybackInfo data = await Api.playbackInfo(source.fileId);
      return PlayerFileInfo(
        url: Uri.parse(data.url).normalize(),
        subtitles: data.subtitles.map((d) => d.toSubtitle()).nonNulls.toList(),
        others: data.others,
      );
    } else if (source is DriverFile) {
      final PlaybackInfo data = await Api.playbackInfo(source.fileId);
      return PlayerFileInfo(
        url: Uri.parse(data.url).normalize(),
        subtitles: data.subtitles.map((d) => d.toSubtitle()).nonNulls.toList(),
        others: data.others,
      );
    }
    if (item.url != null) {
      return PlayerFileInfo(url: item.url!);
    }
    throw Exception();
  }

  Future<void> _onPlaybackStatusUpdate(
    dynamic others,
    PlaybackStatusEvent eventType,
    Duration position,
    Duration duration,
  ) {
    final dynamic source = _controller.currentItem!.source;
    final LibraryType? libraryType = switch (source) {
      final TVEpisode _ => LibraryType.tv,
      final Movie _ => LibraryType.movie,
      _ => null,
    };
    if (libraryType == null) {
      return Future.value();
    }
    return Api.updatePlayedStatus(
      libraryType,
      (source as MediaBase).id,
      position: position,
      duration: duration,
      eventType: switch (eventType) {
        PlaybackStatusEvent.start => PlayedStatusUpdateEventType.start,
        PlaybackStatusEvent.progress => PlayedStatusUpdateEventType.progress,
        PlaybackStatusEvent.stop => PlayedStatusUpdateEventType.stop,
      },
      others: others,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserConfig userConfig = context.read<UserConfig>();
    return Stack(
      children: [
        PlayerPlatformView(
          playerType: userConfig.playerType,
          mpvVersion: userConfig.mpvVersion,
          autoPip: userConfig.autoPip,
          initialized: () async {
            try {
              assert(widget.data.activeIndex.clamp(0, widget.data.playlist.length - 1) == widget.data.activeIndex);
              _controller.setPlaylist(widget.data.playlist);
              await _controller.next(widget.data.activeIndex);
              await _controller.play();
            } catch (e) {
              _controller.playlistError.value = e;
            }
          },
          initializeFailed: (e) => _controller.fatalError.value = e.message,
        ),
        Theme(
          data: darkTheme,
          child: ListenableBuilder(
            listenable: _controller.playlistError,
            builder: (context, child) => _controller.playlistError.value == null
                ? child!
                : Center(child: ErrorMessage(error: _controller.playlistError.value)),
            child: ThemeBuilder(widget.data.themeColor, builder: (_) => PlayerControls(controller: _controller)),
          ),
        ),
      ],
    );
  }
}
