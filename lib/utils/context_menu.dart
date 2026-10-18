import 'dart:math';

import 'package:flutter/material.dart';

extension ContextMenuExtension on BuildContext {
  Future<T?> showContextMenu<T>(List<Widget> items) {
    if (items.isEmpty) {
      return Future.value();
    }
    return showModalBottomSheet<T>(
      context: this,
      showDragHandle: true,
      useSafeArea: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => Scrollbar(
        child: ListTileTheme(
          dense: true,
          child: Scrollbar(
            child: ListView(
              physics: const RangeMaintainingScrollPhysics(),
              padding: EdgeInsets.only(bottom: max(MediaQuery.of(context).padding.bottom, 16)),
              shrinkWrap: true,
              children: items
                  .map(
                    (item) => switch (item) {
                      final ListTile item => ListTile(
                        title: item.title,
                        subtitle: item.subtitle,
                        leading: item.leading,
                        selected: item.selected,
                        enabled: item.enabled,
                        onTap: item.onTap != null
                            ? () {
                                Navigator.of(context).pop();
                                item.onTap?.call();
                              }
                            : null,
                      ),
                      _ => item,
                    },
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
    // final button = findRenderObject()! as RenderBox;
    // final overlay = Navigator.of(this).overlay!.context.findRenderObject()! as RenderBox;
    // final position = RelativeRect.fromRect(
    //   Rect.fromPoints(
    //     button.localToGlobal(Offset.zero, ancestor: overlay),
    //     button.localToGlobal(button.size.bottomRight(Offset.zero) + Offset.zero, ancestor: overlay),
    //   ),
    //   Offset.zero & overlay.size,
    // );
    // return showMenu(context: this, position: position, items: items);
  }
}
