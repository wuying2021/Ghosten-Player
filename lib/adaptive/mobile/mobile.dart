import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../viewers/singleton_player.dart';

export 'package:flutter/src/material/list_tile.dart';
export 'package:flutter/src/material/radio_list_tile.dart';
export 'package:flutter/src/material/scrollbar.dart';
export 'package:flutter/src/material/switch_list_tile.dart';
export 'package:flutter/src/material/text_form_field.dart';

export 'components/action_list_tile.dart';
export 'components/carousel.dart';
export 'components/carousel_item.dart';
export 'components/edit_page.dart';
export 'components/image_card.dart';
export 'components/menu_list_tile.dart';
export 'components/orientation_page.dart';
export 'components/player_subtitle_setting.dart';
export 'details/episode.dart';
export 'details/movie.dart';
export 'details/season.dart';
export 'details/series.dart';
export 'dialogs/confirm.dart';
export 'home.dart';
export 'player/player_controls.dart';
export 'theme.dart';
export 'wrapper.dart';

const bool kIsTV = false;

final settingNavigatorKey = GlobalKey<NavigatorState>();

class Series2Page extends StatelessWidget {
  const Series2Page({super.key, this.data, required this.id});

  final TVSeries? data;
  final dynamic id;

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class LivePlayerPage extends StatelessWidget {
  const LivePlayerPage({super.key, required this.data});

  final PlaylistData data;

  @override
  Widget build(BuildContext context) {
    return SingletonPlayer(data: data);
  }
}
