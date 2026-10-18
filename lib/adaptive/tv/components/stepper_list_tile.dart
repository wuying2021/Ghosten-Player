import 'package:flutter/material.dart' hide ListTile, RadioListTile;
import 'package:flutter/services.dart';

import 'list_tile.dart';

class StepperListTile extends StatelessWidget {
  const StepperListTile({
    super.key,
    required this.title,
    this.max,
    this.min,
    this.step = 1,
    this.onChanged,
    required this.value,
  });

  final Widget title;
  final int value;
  final int? max;
  final int? min;
  final int step;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      trailing: Focus(
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent || event is KeyRepeatEvent) {
            switch (event.logicalKey) {
              case LogicalKeyboardKey.arrowLeft:
                if (min == null || value > min! && onChanged != null) {
                  onChanged!(_clamp(value - step));
                }
                return KeyEventResult.handled;
              case LogicalKeyboardKey.arrowRight:
                if (max == null || value < max! && onChanged != null) {
                  onChanged!(_clamp(value + step));
                }
                return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary),
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(1000),
          ),
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.remove,
                  size: 16,
                  color: min == null || value > min!
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              SizedBox(
                width: 20,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.add,
                  size: 16,
                  color: max == null || value < max!
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _clamp(int v) {
    if (max != null) {
      v = v < max! ? v : max!;
    }
    if (min != null) {
      v = v > min! ? v : min!;
    }
    return v;
  }
}
