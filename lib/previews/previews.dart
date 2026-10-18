import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../adaptive/adaptive.dart';
import '../l10n/app_localizations.dart';

final class AppPreview extends MultiPreview {
  const AppPreview({this.size, this.group, this.name});

  final Size? size;
  final String? name;
  final String? group;

  @override
  List<Preview> get previews => [
    Preview(
      group: group ?? 'Default',
      name: name,
      size: size,
      localizations: () => const PreviewLocalizationsData(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('zh', 'CN'),
      ),
      wrapper: (child) => Builder(
        builder: (context) => Theme(
          data: switch (MediaQuery.platformBrightnessOf(context)) {
            Brightness.dark => darkTheme,
            Brightness.light => lightTheme,
          },
          child: Container(
            decoration: BoxDecoration(
              color: switch (MediaQuery.platformBrightnessOf(context)) {
                Brightness.dark => Colors.black,
                Brightness.light => Colors.white,
              },
            ),
            clipBehavior: .hardEdge,
            child: Center(child: child),
          ),
        ),
      ),
    ),
  ];
}
