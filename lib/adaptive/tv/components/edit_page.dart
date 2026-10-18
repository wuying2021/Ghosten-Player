import 'package:flutter/material.dart';

import '../../../components/keyboard_reopen.dart';
import '../../../components/setting_page.dart';
import '../../../components/setting_page_theme.dart';
import '../../../l10n/app_localizations.dart';
import '_input_assistance.dart';

class EditPage extends StatelessWidget {
  const EditPage({
    super.key,
    required this.child,
    this.title,
    this.bottom,
    this.onConfirmButtonPressed,
    this.onResetButtonPressed,
    this.useAssistance,
  });

  final Widget? title;
  final PreferredSizeWidget? bottom;
  final Widget child;
  final VoidCallback? onConfirmButtonPressed;
  final VoidCallback? onResetButtonPressed;
  final bool? useAssistance;

  @override
  Widget build(BuildContext context) {
    final actions = SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: OverflowBar(
          overflowAlignment: .end,
          alignment: .end,
          spacing: 8,
          children: [
            if (onResetButtonPressed != null)
              TextButton(
                onPressed: onResetButtonPressed,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  minimumSize: .zero,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                ),
                child: Text(AppLocalizations.of(context)!.buttonReset),
              ),
            if (onConfirmButtonPressed != null)
              FilledButton(
                onPressed: onConfirmButtonPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                  foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
                  minimumSize: .zero,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                ),
                child: Text(AppLocalizations.of(context)!.buttonConfirm),
              ),
          ],
        ),
      ),
    );
    return useAssistance ?? true
        ? Row(
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: DecoratedBox(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg-wheat.webp'),
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: .center,
                      spacing: 20,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: InputAssistance(
                            onData: (data) {
                              final BuildContext? ctx = FocusManager.instance.primaryFocus?.context;
                              final TextField? textField = ctx?.findAncestorWidgetOfExactType<TextField>();
                              if (textField?.controller != null) {
                                textField!.controller!.text += data;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: title,
                    backgroundColor: Colors.transparent,
                    bottom: bottom,
                  ),
                  body: Column(
                    children: [
                      Expanded(child: KeyboardReopen(child: child)),
                      actions,
                    ],
                  ),
                ),
              ),
            ],
          )
        : SettingPage(
            title: title,
            child: Column(
              children: [
                Expanded(
                  child: KeyboardReopen(
                    child: Padding(
                      padding: SettingPageTheme.of(context).contentPadding?.copyWith(bottom: 12) ?? .zero,
                      child: child,
                    ),
                  ),
                ),
                actions,
              ],
            ),
          );
  }
}
