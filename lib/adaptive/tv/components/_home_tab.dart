import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../previews/previews.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key, required this.tabs, required this.onTabChange, this.activeIndex});

  final List<String> tabs;
  final ValueChanged<int> onTabChange;
  final int? activeIndex;

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  double _lineWidth = 0;
  double _lineOffset = 0;
  bool _tabFocused = false;
  late int _active = widget.activeIndex ?? 0;
  late final List<GlobalKey> _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());

  @override
  void didUpdateWidget(covariant HomeTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeIndex != _active && widget.activeIndex != null) {
      _active = widget.activeIndex!;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 10)).then(
      (_) => setState(() {
        _updateActiveLine(_tabKeys[_active].currentContext!);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = switch (Theme.of(context).brightness) {
      Brightness.dark => Colors.white,
      Brightness.light => Colors.black,
    };
    return Focus(
      autofocus: true,
      onFocusChange: (f) {
        if (_tabFocused != f) {
          setState(() {
            _tabFocused = f;
          });
        }
      },
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowLeft:
              if (_active > 0) {
                _active -= 1;
                widget.onTabChange(_active);
                _updateActiveLine(_tabKeys[_active].currentContext!);
                setState(() {});
                return KeyEventResult.handled;
              }

            case LogicalKeyboardKey.arrowRight:
              if (_active < widget.tabs.length - 1) {
                _active += 1;
                widget.onTabChange(_active);
                _updateActiveLine(_tabKeys[_active].currentContext!);
              } else {
                final List<FocusNode> siblings = node.parent!.children.toList();
                final int index = siblings.indexOf(node);
                siblings[index + 1].requestFocus();
              }
              setState(() {});
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: RepaintBoundary(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.tabs.indexed
                  .map(
                    (tab) => GestureDetector(
                      onTap: () {
                        _active = tab.$1;
                        widget.onTabChange(_active);
                        _updateActiveLine(_tabKeys[_active].currentContext!);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        child: Text(
                          tab.$2,
                          key: _tabKeys[tab.$1],
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: tab.$1 == _active && _tabFocused ? color : Colors.grey),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (_lineWidth > 0)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutExpo,
                width: _tabFocused ? _lineWidth : _lineWidth * 0.6,
                height: 2,
                margin: EdgeInsets.only(left: _tabFocused ? _lineOffset : _lineOffset + _lineWidth * 0.2),
                decoration: BoxDecoration(
                  color: _tabFocused ? color : Colors.grey,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateActiveLine(BuildContext context) {
    final box = context.findRenderObject()! as RenderBox;
    final Offset offset = box.globalToLocal(Offset.zero, ancestor: box.parent?.parent?.parent?.parent);
    _lineWidth = box.size.width;
    _lineOffset = -offset.dx;
  }
}

@AppPreview(group: 'Home Tabs (TV)', size: Size.fromWidth(300))
Widget homeAppbarPreview() {
  return Builder(
    builder: (context) {
      return HomeTabs(tabs: const ['TV', 'Movie', 'Live'], onTabChange: (value) {});
    },
  );
}
