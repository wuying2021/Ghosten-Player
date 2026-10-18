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
const _cardTheme = CardThemeData(elevation: 6, clipBehavior: .antiAlias);
const _filledButtonTheme = FilledButtonThemeData(style: ButtonStyle());
final List<AppTheme> _extensions = [_mobileAppTheme];
const _drawerTheme = DrawerThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  endShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
);

final lightTheme = ThemeData(
  actionIconTheme: _actionIconTheme,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0.75,
    shadowColor: Color(0xFFFCFCFF),
    backgroundColor: Color(0xFFFCFCFF),
  ),
  bottomSheetTheme: _bottomSheetTheme,
  cardTheme: _cardTheme,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3558C4)),
  dialogTheme: _dialogTheme,
  dividerTheme: const DividerThemeData(color: Colors.black12),
  dividerColor: Colors.black12,
  drawerTheme: _drawerTheme,
  extensions: _extensions,
  filledButtonTheme: _filledButtonTheme,
  textTheme: const TextTheme(labelSmall: TextStyle(color: Color(0xFF666666))),
);

final darkTheme = ThemeData(
  actionIconTheme: _actionIconTheme,
  appBarTheme: const AppBarTheme(scrolledUnderElevation: 0.75),
  bottomSheetTheme: _bottomSheetTheme,
  cardTheme: _cardTheme,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF98C2FF), brightness: Brightness.dark),
  dialogTheme: _dialogTheme,
  dividerColor: Colors.white12,
  dividerTheme: const DividerThemeData(color: Colors.white12),
  drawerTheme: _drawerTheme,
  filledButtonTheme: _filledButtonTheme,
  extensions: _extensions,
  textTheme: const TextTheme(labelSmall: TextStyle(color: Color(0xFFAAAAAA))),
);

final _mobileAppTheme = AppTheme(
  horizontalListTheme: const HorizontalListThemeData(
    headerPadding: EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
    padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
    itemSpacing: 4,
  ),
  wrapListTheme: const WrapListThemeData(
    headerPadding: EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
    spacing: 4,
    runSpacing: 4,
  ),
  settingPageTheme: SettingPageThemeData(
    appbarTheme: (context) =>
        AppBarThemeData(shadowColor: Colors.transparent, backgroundColor: Theme.of(context).scaffoldBackgroundColor),
    contentPadding: .zero,
  ),
  aspectRatioGridTheme: const AspectRatioGridThemeData(crossAxisSpacing: 4, mainAxisSpacing: 16),
  movieCardTheme: const MediaCardThemeData(minWidth: 120, aspectRatio: 2 / 3, heightExtent: 64),
  seriesCardTheme: const MediaCardThemeData(minWidth: 120, aspectRatio: 2 / 3, heightExtent: 64),
  seasonCardTheme: const MediaCardThemeData(minWidth: 120, aspectRatio: 2 / 3, heightExtent: 64),
  episodeCardTheme: const MediaCardThemeData(minWidth: 188, aspectRatio: 16 / 9, heightExtent: 78),
  castCardTheme: const MediaCardThemeData(minWidth: 90, aspectRatio: 2 / 3, heightExtent: 95),
  crewCardTheme: const MediaCardThemeData(minWidth: 90, aspectRatio: 2 / 3, heightExtent: 94),
  channelsContentPadding: .zero,
  channelsListViewPadding: .zero,
  mediaListTheme: const MediaListThemeData(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
  numberPickerTheme: const NumberPickerThemeData(),
  functions: const Functions(
    autoForceLandscape: true,
    autoPip: true,
    shortcuts: false,
    menuShortcuts: true,
    displaySize: true,
  ),
);
