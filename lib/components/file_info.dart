import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/utils.dart';
import 'future_builder_handler.dart';
import 'loading.dart';

class FileInfoSection extends StatelessWidget {
  const FileInfoSection({super.key, required this.fileId});

  final String fileId;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FutureBuilderHandler(
            future: Api.fileInfo(fileId),
            loadingBuilder: (context, _) => const Padding(padding: EdgeInsets.all(8.0), child: Loading()),
            builder: (context, snapshot) {
              final DriverFileInfo item = snapshot.requireData;
              return Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(12),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  child: Table(
                    border: TableBorder.all(width: 0, color: Colors.transparent),
                    columnWidths: const <int, TableColumnWidth>{0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                            child: Text(AppLocalizations.of(context)!.filePropertyDriverType),
                          ),
                          Text(AppLocalizations.of(context)!.driverType(item.driverType.name)),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                            child: Text(AppLocalizations.of(context)!.filePropertyFilename),
                          ),
                          Text(item.filename ?? ''),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                            child: Text(AppLocalizations.of(context)!.filePropertySize),
                          ),
                          Text(item.size?.toSizeDisplay() ?? ''),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                            child: Text(AppLocalizations.of(context)!.filePropertyCreateAt),
                          ),
                          Text(item.createdAt.formatFull()),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
