import 'package:flutter/material.dart' hide Scrollbar;

export 'components/action_list_tile.dart';
export 'components/carousel.dart';
export 'components/carousel_item.dart';
export 'components/edit_page.dart';
export 'components/image_card.dart';
export 'components/list_tile.dart';
export 'components/menu_list_tile.dart';
export 'components/orientation_page.dart';
export 'components/player_subtitle_setting.dart';
export 'components/radio_list_tile.dart';
export 'components/switch_list_tile.dart';
export 'components/text_form_field.dart';
export 'details/episode.dart';
export 'details/movie.dart';
export 'details/season.dart';
export 'details/series.dart';
export 'details/series2.dart';
export 'dialogs/confirm.dart';
export 'home.dart';
export 'player/live_player.dart';
export 'player/player_controls.dart';
export 'theme.dart';
export 'wrapper.dart';

const bool kIsTV = true;
final settingNavigatorKey = GlobalKey<NavigatorState>();

class Scrollbar extends StatelessWidget {
  const Scrollbar({super.key, required this.child, this.controller});

  final Widget child;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
