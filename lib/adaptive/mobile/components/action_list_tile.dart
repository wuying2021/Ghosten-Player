import 'package:flutter/material.dart';

import '../../../menus/abstract.dart';
import '../../../utils/utils.dart';

enum ActionSide { start, end }

class ActionListTile extends StatelessWidget {
  const ActionListTile({
    super.key,
    required this.title,
    this.autofocus = false,
    this.selected = false,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.actionSide = .end,
    required this.actions,
  });

  final bool autofocus;
  final bool selected;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final ActionSide actionSide;
  final Menu actions;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      autofocus: autofocus,
      selected: selected,
      leading: leading,
      trailing: trailing,
      onTap: onTap ?? () => _showContextMenu(context),
      onLongPress: onTap != null ? () => _showContextMenu(context) : null,
    );
  }

  void _showContextMenu(BuildContext context) {
    context.showContextMenu(actions.buildSettingItems(context));
  }
}
