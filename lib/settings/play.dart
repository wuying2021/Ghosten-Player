import 'package:api/api.dart';
import 'package:flutter/material.dart' hide TextFormField;
import 'package:video_player/player.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';

class SettingsPlayPage extends StatefulWidget {
  const SettingsPlayPage({super.key});

  @override
  State<SettingsPlayPage> createState() => _SettingsPlayPageState();
}

class _SettingsPlayPageState extends State<SettingsPlayPage> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController();
  DriverFile? _storageFile;

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(AppLocalizations.of(context)!.buttonPlay),
      onConfirmButtonPressed: () => _onSubmit(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                  isDense: true,
                  border: const UnderlineInputBorder(),
                  labelText: 'Link',
                  prefixIcon: const Icon(Icons.link),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_open_rounded),
                    onPressed: () async {
                      final (int, DriverFile)? res = await showDriverFilePicker(
                        context,
                        '',
                        selectableType: FileType.file,
                      );
                      if (res != null) {
                        final DriverFile file = res.$2;
                        _controller.text = file.name;
                        _storageFile = file;
                        setState(() {});
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if (_controller.text.trim().isEmpty) {
                    return AppLocalizations.of(context)!.formValidatorRequired;
                  }
                  if (_storageFile != null) {
                    return null;
                  }
                  final Uri? uri = Uri.tryParse(_controller.text);
                  if (uri == null || !uri.hasScheme) {
                    return AppLocalizations.of(context)!.formValidatorUrl;
                  }
                  return null;
                },
                onChanged: (_) {
                  _storageFile = null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await context.pushNamed(
        .player,
        arguments: {
          'playlist': [PlaylistItem(url: Uri.tryParse(_controller.text), source: _storageFile)],
        },
      );
    }
  }
}
