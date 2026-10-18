import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile, TextFormField;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:video_player/player.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../validators/validators.dart';
import '../adaptive/adaptive.dart';

class SubtitleManager extends StatefulWidget {
  const SubtitleManager({super.key, required this.fileId});

  final String fileId;

  @override
  State<SubtitleManager> createState() => _SubtitleManagerState();
}

class _SubtitleManagerState extends State<SubtitleManager> {
  @override
  Widget build(BuildContext context) {
    return SettingPage(
      title: Text(AppLocalizations.of(context)!.buttonSubtitle),
      actions: [
        IconButton(
          onPressed: () async {
            final Object? subtitle = await context.pushNamed(.subtitleAdd);
            if (subtitle is SubtitleData && context.mounted) {
              final AsyncSnapshot<void>? resp = await showNotification(context, Api.subtitleInsert(widget.fileId, subtitle));
              if (resp?.error == null && context.mounted) {
                setState(() {});
              }
            }
          },
          icon: const Icon(Icons.add),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilderHandler(
            future: Api.subtitleQueryById(widget.fileId),
            builder: (context, snapshot) => snapshot.requireData.isNotEmpty
                ? ListView.builder(
                    itemCount: snapshot.requireData.length,
                    itemBuilder: (context, index) {
                      final SubtitleData item = snapshot.requireData[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 48 / constraints.maxWidth,
                          motion: const BehindMotion(),
                          children: [
                            IconButton(
                              onPressed: () async {
                                final bool? confirm = await showConfirm(
                                  context,
                                  AppLocalizations.of(context)!.deleteConfirmText,
                                );
                                if (confirm != true || !context.mounted) {
                                  return;
                                }
                                final AsyncSnapshot<void>? resp = await showNotification(context, Api.subtitleDeleteById(item.id));
                                if (resp?.error == null && context.mounted) {
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Text(item.mimeType.toString()),
                          trailing: Text(item.language ?? ''),
                          title: Text(item.label ?? ''),
                        ),
                      );
                    },
                  )
                : const NoData(),
          );
        },
      ),
    );
  }
}

class SubtitleDialog extends StatefulWidget {
  const SubtitleDialog({super.key, this.subtitle});

  final SubtitleData? subtitle;

  @override
  State<SubtitleDialog> createState() => _SubtitleDialogState();
}

class _SubtitleDialogState extends State<SubtitleDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SubtitleType? _mimeType;
  String? _language;
  String? _filename;
  bool selected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(AppLocalizations.of(context)!.buttonSubtitle),
      onConfirmButtonPressed: () {
        if (_formKey.currentState!.validate() && _mimeType != null) {
          Navigator.of(context).pop(
            SubtitleData(
              url: _controller.text,
              mimeType: _mimeType!,
              language: _language,
              label: _filename,
              selected: selected,
            ),
          );
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
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.link),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open_rounded),
                  onPressed: () async {
                    final (int, DriverFile)? res = await showDriverFilePicker(
                      context,
                      AppLocalizations.of(context)!.titleEditSubtitle,
                      selectableType: FileType.file,
                    );
                    if (res != null) {
                      final DriverFile file = res.$2;
                      final List<String> ar = file.name.split('.');
                      final String? ext = ar.lastOrNull;
                      _mimeType = SubtitleType.fromString(ext);
                      _filename = ar.firstOrNull;
                      _controller.text = 'driver://${res.$1}/${file.id}';
                      setState(() {});
                    }
                  },
                ),
                hintText: widget.subtitle?.label?.toString(),
                isDense: true,
                labelText: AppLocalizations.of(context)!.subtitleFormItemLabelUrl,
              ),
              validator: (value) => requiredValidator(context, value),
              onChanged: (value) {
                if (value.startsWith(RegExp(r'^http(s)://'))) {
                  final Uri uri = Uri.parse(value.trim());
                  final String? filename = uri.path.split('/').lastOrNull;
                  final List<String>? ar = filename?.split('.');
                  final String? ext = ar?.lastOrNull;
                  _filename = ar?.firstOrNull;
                  _mimeType = SubtitleType.fromString(ext);
                  setState(() {});
                }
              },
            ),
            Gap.vSM,
            DropdownButtonFormField(
              initialValue: _mimeType,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.subtitles_outlined),
                isDense: true,
                labelText: AppLocalizations.of(context)!.subtitleFormItemLabelType,
              ),
              items: [
                DropdownMenuItem(
                  child: Text(
                    AppLocalizations.of(context)!.formItemNotSelectedHint,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                ...SubtitleMimeType.values.map(
                  (mime) => DropdownMenuItem(value: mime.name, child: Text(mime.name.toUpperCase())),
                ),
              ],
              validator: (value) => requiredValidator(context, value),
              onChanged: (v) => setState(() => _mimeType = v),
            ),
            Gap.vSM,
            DropdownButtonFormField(
              initialValue: _language,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.language),
                isDense: true,
                labelText: AppLocalizations.of(context)!.subtitleFormItemLabelLanguage,
              ),
              items: [
                DropdownMenuItem(
                  child: Text(
                    AppLocalizations.of(context)!.formItemNotSelectedHint,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                ...SupportedLanguages.values.map(
                  (lang) => DropdownMenuItem(value: lang.name, child: Text(lang.name.toUpperCase())),
                ),
              ],
              onChanged: (v) => setState(() => _language = v),
            ),
            Gap.vSM,
            CheckboxListTile(
              dense: true,
              title: Text(AppLocalizations.of(context)!.formLabelSelectedByDefault),
              contentPadding: const EdgeInsets.only(left: 8),
              value: selected,
              onChanged: (v) => setState(() => selected = v ?? false),
            ),
          ],
        ),
      ),
    );
  }
}
