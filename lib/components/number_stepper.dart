import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberStepper extends StatelessWidget {
  const NumberStepper({super.key, this.max, this.min, this.step = 1, required this.onChanged, required this.value})
    : assert(value != null || min != null),
      assert(min == null || max == null || max > min);

  final int? value;
  final int? max;
  final int? min;
  final int step;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowLeft:
              onChanged(clamp((value ?? min!) - step));
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowRight:
              onChanged(clamp((value ?? min!) + step));
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
            GestureDetector(
              onTap: value == null || min == null || value! > min!
                  ? () => onChanged(clamp((value ?? min!) - step))
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.remove,
                  size: 16,
                  color: value == null || min == null || value! > min!
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
            SizedBox(width: 20, child: Text(value?.toString() ?? '', textAlign: TextAlign.center)),
            GestureDetector(
              onTap: value == null || max == null || value! < max!
                  ? () => onChanged(clamp((value ?? min!) + step))
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.add,
                  size: 16,
                  color: value == null || max == null || value! < max!
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int clamp(int v) {
    if (max != null) {
      v = v < max! ? v : max!;
    }
    if (min != null) {
      v = v > min! ? v : min!;
    }
    return v;
  }
}
