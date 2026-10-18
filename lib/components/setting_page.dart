import 'package:flutter/material.dart' hide Scrollbar;

import '../adaptive/adaptive.dart';
import 'setting_page_theme.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, this.title, required this.child, this.actions, this.floatingActionButton})
    : children = null;

  const SettingPage.list({super.key, this.title, required this.children, this.actions, this.floatingActionButton})
    : child = null;

  final Widget? title;
  final Widget? child;
  final List<Widget>? children;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    assert(child != null || children != null);
    final SettingPageThemeData theme = SettingPageTheme.of(context);
    final Widget body =
        child ??
        Scrollbar(
          child: ListView(
            padding: theme.contentPadding?.add(.only(bottom: MediaQuery.paddingOf(context).bottom)),
            children: children!,
          ),
        );
    return AppBarTheme(
      data: theme.appbarTheme?.call(context),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: (title != null || actions != null)
            ? AppBar(title: title, automaticallyImplyLeading: theme.automaticallyImplyLeading ?? true, actions: actions)
            : null,
        floatingActionButton: floatingActionButton,
        backgroundColor: theme.backgroundColor?.call(context),
        body: body,
      ),
    );
  }
}
