import 'package:api/api.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 记录并恢复上次播放的 IPTV 播放列表与频道，用于启动时自动播放。
class IptvAutoPlay {
  static const _kPlaylistId = 'iptv.lastPlaylistId';
  static const _kChannelIndex = 'iptv.lastChannelIndex';

  /// 返回 (播放列表 id, 频道列表, 频道下标)；没有可播放的频道时返回 null。
  static Future<(int, List<Channel>, int)?> load() async {
    final playlists = await Api.playlistQueryAll();
    if (playlists.isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getInt(_kPlaylistId);
    final playlist = playlists.firstWhereOrNull((p) => p.id == lastId) ?? playlists.first;
    final channels = await Api.playlistChannelsQueryById(playlist.id);
    if (channels.isEmpty) return null;
    var index = playlist.id == lastId ? (prefs.getInt(_kChannelIndex) ?? 0) : 0;
    if (index < 0 || index >= channels.length) index = 0;
    return (playlist.id, channels, index);
  }

  static Future<void> save(int playlistId, int channelIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kPlaylistId, playlistId);
    await prefs.setInt(_kChannelIndex, channelIndex);
  }
}
