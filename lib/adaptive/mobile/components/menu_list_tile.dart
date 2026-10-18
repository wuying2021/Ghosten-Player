import 'package:flutter/material.dart';

class MenuListTile<T> extends StatelessWidget {
  const MenuListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    required this.onSelected,
    required this.itemBuilder,
    this.initialValue,
  });

  final T? initialValue;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final PopupMenuItemSelected<T> onSelected;
  final PopupMenuItemBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      offset: const Offset(1, 0),
      tooltip: '',
      initialValue: initialValue,
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      child: ListTile(leading: leading, trailing: trailing, title: title, subtitle: subtitle),
    );
  }
}
