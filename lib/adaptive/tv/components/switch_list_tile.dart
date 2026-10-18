import 'package:flutter/material.dart' as ma;

import '_fluid_focusable.dart';

class SwitchListTile extends ma.StatefulWidget {
  const SwitchListTile({
    super.key,
    this.title,
    this.subtitle,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.selected = false,
    required this.value,
    this.onChanged,
  });

  final ma.Widget? title;
  final ma.Widget? subtitle;
  final bool autofocus;
  final ma.FocusNode? focusNode;
  final ma.ValueChanged<bool>? onFocusChange;
  final bool selected;
  final bool value;
  final ma.ValueChanged<bool>? onChanged;

  @override
  ma.State<SwitchListTile> createState() => _SwitchListTileState();
}

class _SwitchListTileState extends ma.State<SwitchListTile> {
  late final ma.FocusNode _focusNode = widget.focusNode ?? ma.FocusNode();

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode != null) {
      _focusNode.dispose();
    }
  }

  @override
  ma.Widget build(ma.BuildContext context) {
    return FluidFocusable(
      focusNode: _focusNode,
      backgroundColor: ma.Colors.transparent,
      child: ma.SwitchListTile(
        value: widget.value,
        autofocus: widget.autofocus,
        selected: widget.selected,
        focusNode: _focusNode,
        onFocusChange: widget.onFocusChange,
        title: widget.title,
        subtitle: widget.subtitle,
        onChanged: widget.onChanged,
      ),
    );
  }
}
