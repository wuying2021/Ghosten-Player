import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../validators/validators.dart';
import '../adaptive/adaptive.dart';

class LiveEditPage extends StatefulWidget {
  const LiveEditPage({super.key, this.item});

  final Playlist? item;

  @override
  State<LiveEditPage> createState() => _LiveEditPageState();
}

class _LiveEditPageState extends State<LiveEditPage> {
  late final _controller = TextEditingController(text: widget.item?.url);
  late final _formGroup = FormGroupController([
    FormItem(
      'title',
      labelText: AppLocalizations.of(context)!.liveCreateFormItemLabelTitle,
      prefixIcon: const Icon(Icons.live_tv),
      validator: (value) => requiredValidator(context, value),
      value: widget.item?.title,
    ),
    FormItem(
      'url',
      labelText: AppLocalizations.of(context)!.liveCreateFormItemLabelUrl,
      helperText: AppLocalizations.of(context)!.liveCreateFormItemHelperUrl,
      prefixIcon: const Icon(Icons.link),
      suffixIcon: IconButton(
        icon: const Icon(Icons.folder_open_rounded),
        onPressed: () async {
          final (int, DriverFile)? res = await showDriverFilePicker(
            context,
            AppLocalizations.of(context)!.titleEditM3U,
            selectableType: FileType.file,
          );
          if (res != null) {
            final DriverFile file = res.$2;
            _controller.text = 'driver://${res.$1}/${file.id}';
            setState(() {});
          }
        },
      ),
      controller: _controller,
      validator: (value) => urlValidator(context, value, true),
      value: widget.item?.url,
    ),
  ]);

  @override
  void dispose() {
    _formGroup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(
        widget.item == null ? AppLocalizations.of(context)!.pageTitleAdd : AppLocalizations.of(context)!.pageTitleEdit,
      ),
      onConfirmButtonPressed: () => _onSubmit(context),
      child: FormGroup(controller: _formGroup),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formGroup.validate()) {
      if (widget.item == null) {
        final AsyncSnapshot<void>? resp = await showNotification(
          context,
          Api.playlistInsert(_formGroup.data['url'], _formGroup.data['title']),
        );
        if (resp?.error == null && context.mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        final AsyncSnapshot<void>? resp = await showNotification(
          context,
          Api.playlistUpdateById(widget.item!.id, _formGroup.data['url'], _formGroup.data['title']),
        );
        if (resp?.error == null && context.mounted) {
          Navigator.of(context).pop(true);
        }
      }
    }
  }
}
