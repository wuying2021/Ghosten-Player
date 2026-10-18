import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../extensions/extensions.dart';
import '../../medias/media_list_theme.dart';

const fontFamily = 'Roboto Condensed';
const _bottomSheetTheme = BottomSheetThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
);
const _dialogTheme = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.0))),
);

final _actionIconTheme = ActionIconThemeData(
  backButtonIconBuilder: (context) => const Icon(Icons.chevron_left_rounded),
  endDrawerButtonIconBuilder: (context) => const Icon(Icons.more_vert_rounded),
);
final lightColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF98C2FF));
final darkColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF98C2FF), brightness: Brightness.dark);
const _drawerTheme = DrawerThemeData(shape: RoundedRectangleBorder(), endShape: RoundedRectangleBorder());
const _scrollbarTheme = ScrollbarThemeData(radius: Radius.circular(10));
final _lightButtonStyle = ButtonStyle(
  side: WidgetStateProperty.fromMap({
    WidgetState.focused: BorderSide(width: 3, color: lightColorScheme.inverseSurface, strokeAlign: 2),
  }),
);
final _darkButtonStyle = ButtonStyle(
  side: WidgetStateProperty.fromMap({
    WidgetState.focused: BorderSide(width: 3, color: darkColorScheme.inverseSurface, strokeAlign: 2),
  }),
);

final lightTheme = ThemeData(
  actionIconTheme: _actionIconTheme,
  bottomSheetTheme: _bottomSheetTheme,
  colorScheme: lightColorScheme,
  dialogTheme: _dialogTheme,
  drawerTheme: _drawerTheme,
  dividerTheme: const DividerThemeData(color: Colors.black12, indent: 16, endIndent: 16),
  dividerColor: Colors.black12,
  extensions: [tvAppTheme],
  filledButtonTheme: FilledButtonThemeData(style: _lightButtonStyle),
  fontFamily: fontFamily,
  iconButtonTheme: IconButtonThemeData(style: _lightButtonStyle),
  listTileTheme: const ListTileThemeData(
    subtitleTextStyle: TextStyle(fontSize: 12, color: Color(0xFF666666)),
    visualDensity: .compact,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
  ),
  scrollbarTheme: _scrollbarTheme,
  textButtonTheme: TextButtonThemeData(style: _lightButtonStyle),
  textTheme: const TextTheme(labelSmall: TextStyle(color: Color(0xFF666666))),
);

final darkTheme = ThemeData(
  actionIconTheme: _actionIconTheme,
  bottomSheetTheme: _bottomSheetTheme,
  colorScheme: darkColorScheme,
  dialogTheme: _dialogTheme,
  drawerTheme: _drawerTheme,
  dividerTheme: const DividerThemeData(color: Colors.white12, indent: 16, endIndent: 16),
  dividerColor: Colors.white12,
  extensions: [tvAppTheme],
  filledButtonTheme: FilledButtonThemeData(style: _darkButtonStyle),
  fontFamily: fontFamily,
  iconButtonTheme: IconButtonThemeData(style: _darkButtonStyle),
  listTileTheme: const ListTileThemeData(
    subtitleTextStyle: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
    visualDensity: .compact,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
  ),
  scaffoldBackgroundColor: Colors.black,
  scrollbarTheme: _scrollbarTheme,
  textButtonTheme: TextButtonThemeData(style: _darkButtonStyle),
  textTheme: const TextTheme(labelSmall: TextStyle(color: Color(0xFFAAAAAA))),
);

final tvAppTheme = AppTheme(
  horizontalListTheme: const HorizontalListThemeData(
    headerPadding: EdgeInsets.only(left: 48, right: 48, top: 32, bottom: 12),
    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 6),
    itemSpacing: 16,
  ),
  wrapListTheme: const WrapListThemeData(
    headerPadding: EdgeInsets.only(left: 48, right: 48, top: 32, bottom: 12),
    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 6),
    spacing: 4,
    runSpacing: 4,
  ),
  aspectRatioGridTheme: const AspectRatioGridThemeData(crossAxisSpacing: 16, mainAxisSpacing: 16),
  movieCardTheme: const MediaCardThemeData(minWidth: 160, aspectRatio: 2 / 3, heightExtent: 66),
  seriesCardTheme: const MediaCardThemeData(minWidth: 160, aspectRatio: 2 / 3, heightExtent: 66),
  seasonCardTheme: const MediaCardThemeData(minWidth: 160, aspectRatio: 2 / 3, heightExtent: 66),
  episodeCardTheme: const MediaCardThemeData(minWidth: 204, aspectRatio: 16 / 9, heightExtent: 82),
  castCardTheme: const MediaCardThemeData(minWidth: 107, aspectRatio: 2 / 3, heightExtent: 80),
  crewCardTheme: const MediaCardThemeData(minWidth: 107, aspectRatio: 2 / 3, heightExtent: 80),
  settingPageTheme: SettingPageThemeData(
    appbarTheme: (context) => AppBarThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      titleSpacing: 24,
      toolbarHeight: 80,
      titleTextStyle: Theme.of(context).textTheme.titleLarge!
          .copyWith(fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
      actionsPadding: const EdgeInsets.only(right: 8),
    ),
    backgroundColor: (context) => Theme.of(context).colorScheme.surfaceContainerLow,
    automaticallyImplyLeading: false,
    contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 32),
  ),
  channelsContentPadding: const EdgeInsets.symmetric(horizontal: 48),
  channelsListViewPadding: const EdgeInsets.symmetric(horizontal: 6),
  mediaListTheme: const MediaListThemeData(
    automaticallyImplyLeading: false,
    titlePadding: EdgeInsets.only(left: 48, right: 48, top: 32, bottom: 12),
    expandedHeight: 100,
    forceMaterialTransparency: true,
    titleTextStyle: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w400),
    contentPadding: EdgeInsets.symmetric(horizontal: 48, vertical: 24),
  ),
  numberPickerTheme: const NumberPickerThemeData(alwaysShow: false),
  functions: const Functions(
    autoForceLandscape: false,
    autoPip: false,
    shortcuts: true,
    menuShortcuts: false,
    displaySize: false,
  ),
);
