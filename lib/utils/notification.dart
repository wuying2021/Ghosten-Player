import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive.dart';
import '../components/components.dart';
import '../l10n/app_localizations.dart';

const _errorIcon = Icon(Icons.error_rounded, size: 60, color: Color(0xFF8C1D18));
const _successIcon = Icon(Icons.check_circle_rounded, size: 60, color: Colors.lightGreen);

Future<bool?> showConfirm(BuildContext context, String title, [String? description]) async {
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (context) => ConfirmDialog(title: title, description: description),
  );
}

class NotificationResponse<T> {
  const NotificationResponse({this.data, this.error});

  final T? data;
  final Object? error;
}

Future<AsyncSnapshot<T>?> showNotification<T>(
  BuildContext context,
  Future<T> future, {
  String? successText,
  bool showSuccess = false,
}) {
  return showModal(
    context: context,
    // filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    builder: (context) => FutureBuilder(
      future: future,
      builder: (context, snapshot) =>
          _NotificationContent(snapshot: snapshot, successText: successText, showSuccess: showSuccess),
    ),
  );
}

Future<AsyncSnapshot<T?>?> showProgressNotification<T>(
  BuildContext context,
  Stream<double> stream, {
  String? successText,
  bool showSuccess = false,
}) {
  return showModal(
    context: context,
    // filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    builder: (context) => StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => _NotificationContent(
        snapshot: snapshot,
        successText: successText,
        showSuccess: showSuccess,
        progressValue: snapshot.data,
      ),
    ),
  );
}

class _NotificationContent<T> extends StatelessWidget {
  const _NotificationContent({
    super.key,
    required this.snapshot,
    this.successText,
    this.showSuccess = false,
    this.progressValue,
  });

  final AsyncSnapshot<T> snapshot;
  final String? successText;
  final bool showSuccess;
  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop &&
            (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.none)) {
          _pop(context, Duration.zero);
        }
      },
      child: Builder(
        builder: (context) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return progressValue != null
                  ? Center(
                      child: Card(
                        child: SizedBox.square(
                          dimension: 80,
                          child: Center(
                            child: Column(
                              spacing: 6,
                              mainAxisSize: .min,
                              children: [
                                SizedBox.square(dimension: 28, child: CircularProgressIndicator(value: progressValue)),
                                Text(
                                  '${(progressValue! * 100).toStringAsFixed(1)}%',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Loading();
            case ConnectionState.done:
            case ConnectionState.none:
              if (snapshot.hasError) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.modalTitleNotification),
                  content: ErrorMessage(error: snapshot.error, leading: _errorIcon),
                );
              } else {
                if (showSuccess) {
                  _pop(context, const Duration(seconds: 1));
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.modalTitleNotification),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _successIcon,
                        Gap.vMD,
                        Text(successText ?? AppLocalizations.of(context)!.modalNotificationSuccessText),
                      ],
                    ),
                  );
                } else {
                  _pop(context, Duration.zero);
                  return const SizedBox();
                }
              }
          }
        },
      ),
    );
  }

  void _pop(BuildContext context, Duration delay) {
    Future.delayed(delay).then((value) {
      if (context.mounted) {
        Navigator.of(context).pop(snapshot);
      }
    });
  }
}
