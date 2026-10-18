import 'package:api/api.dart';
import 'package:flutter/material.dart' hide TextFormField;

import '../../l10n/app_localizations.dart';
import '../adaptive/adaptive.dart';

class SeasonMetadata extends StatefulWidget {
  const SeasonMetadata({super.key, required this.season});

  final TVSeason season;

  @override
  State<SeasonMetadata> createState() => _SeasonMetadataState();
}

class _SeasonMetadataState extends State<SeasonMetadata> {
  late final _controller = TextEditingController(text: widget.season.season.toString());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(AppLocalizations.of(context)!.titleEditMetadata),
      onConfirmButtonPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.pop(context, int.tryParse(_controller.text));
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            TextFormField(
              autofocus: true,
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.numbers),
                border: const UnderlineInputBorder(),
                isDense: true,
                labelText: AppLocalizations.of(context)!.formLabelSeason,
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final int? season = int.tryParse(value);
                  if (season == null || season < 0 || season > 100) {
                    return AppLocalizations.of(context)!.formValidatorSeason;
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
