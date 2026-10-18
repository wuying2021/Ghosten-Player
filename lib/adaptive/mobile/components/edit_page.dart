import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../previews/previews.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: title,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.buttonCancel),
        ),
        backgroundColor: Colors.transparent,
        bottom: bottom,
        actions: [
          if (onResetButtonPressed != null)
            TextButton(onPressed: onResetButtonPressed, child: Text(AppLocalizations.of(context)!.buttonReset)),
          if (onConfirmButtonPressed != null)
            TextButton(
              onPressed: onConfirmButtonPressed,
              child: Text(
                AppLocalizations.of(context)!.buttonConfirm,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: child,
    );
  }
}

@AppPreview(size: Size.square(200))
Widget editPagePreview() {
  return const EditPage(child: SizedBox());
}
