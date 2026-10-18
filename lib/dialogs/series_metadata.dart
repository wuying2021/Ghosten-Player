import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../validators/validators.dart';
import '../adaptive/adaptive.dart';

class SeriesMetadata extends StatefulWidget {
  const SeriesMetadata({super.key, required this.series});

  final TVSeries series;

  @override
  State<SeriesMetadata> createState() => _SeriesMetadataState();
}

class _SeriesMetadataState extends State<SeriesMetadata> {
  late final _controller = FormGroupController([
    FormItem(
      'title',
      labelText: AppLocalizations.of(context)!.formLabelTitle,
      value: widget.series.title,
      validator: (value) => requiredValidator(context, value),
    ),
    FormItem(
      'originalTitle',
      labelText: AppLocalizations.of(context)!.formLabelOriginalTitle,
      value: widget.series.originalTitle,
      validator: (value) => requiredValidator(context, value),
    ),
    DateFormItem(
      'firstAirDate',
      labelText: AppLocalizations.of(context)!.formLabelAirDate,
      value: widget.series.firstAirDate,
      validator: (value) => requiredValidator(context, value),
    ),
    FormItem(
      'overview',
      labelText: AppLocalizations.of(context)!.formLabelPlot,
      validator: (value) => requiredValidator(context, value),
      value: widget.series.overview,
      maxLines: 6,
    ),
    DoubleFormItem(
      'voteAverage',
      labelText: AppLocalizations.of(context)!.formLabelVoteAverage,
      validator: (value) => requiredValidator(context, value),
      value: widget.series.voteAverage,
    ),
    IntFormItem(
      'voteCount',
      labelText: AppLocalizations.of(context)!.formLabelVoteCount,
      validator: (value) => requiredValidator(context, value),
      value: widget.series.voteCount,
    ),
  ]);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditPage(
      title: Text(AppLocalizations.of(context)!.titleEditMetadata),
      onConfirmButtonPressed: () async {
        if (_controller.validate()) {
          final AsyncSnapshot<void>? resp = await showNotification(
            context,
            Api.tvSeriesMetadataUpdateById({'id': widget.series.id, ..._controller.data}),
          );
          if (resp?.error == null && context.mounted) {
            Navigator.pop(context, true);
          }
        }
      },
      child: FormGroup(controller: _controller, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
    );
  }
}
