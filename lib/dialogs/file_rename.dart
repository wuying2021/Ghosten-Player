import 'package:flutter/material.dart' hide TextFormField;

import '../adaptive/adaptive.dart';
import '../components/components.dart ';
import '../l10n/app_localizations.dart';
import '../validators/validators.dart';

class FilenameDialog extends StatefulWidget {
  const FilenameDialog({super.key, required this.dialogTitle, this.filename});

  final String dialogTitle;
  final String? filename;

  @override
  State<FilenameDialog> createState() => _FilenameDialogState();
}

class _FilenameDialogState extends State<FilenameDialog> {
  late final _controller = TextEditingController(text: widget.filename);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(widget.dialogTitle),
      onConfirmButtonPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.of(context).pop(_controller.text);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: KeyboardReopen(
          child: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(isDense: true, labelText: AppLocalizations.of(context)!.formLabelTitle),
              validator: (value) => requiredValidator(context, value),
            ),
          ),
        ),
      ),
    );
  }
}
