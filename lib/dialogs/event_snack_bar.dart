import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../adaptive/adaptive.dart';
import '../components/components.dart ';

class EventSnackBar extends StatefulWidget {
  const EventSnackBar({super.key});

  @override
  State<EventSnackBar> createState() => _EventSnackBarState();
}

class _EventSnackBarState extends State<EventSnackBar> {
  static final _stream = ReplaySubject<ScheduleTaskEventData>(maxSize: 1)
    ..addStream(Api.scheduleTaskEvent())
    ..stream.asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: switch (Theme.brightnessOf(context)) {
        Brightness.dark => lightTheme,
        Brightness.light => darkTheme,
      },
      child: StreamBuilderHandler(
        stream: _stream,
        builder: (context, snapshot) {
          final ScheduleTaskEventData data = snapshot.requireData;
          switch (data.type) {
            case ScheduleTaskEventType.syncLibrary:
              final d = data.data as List<dynamic>;
              switch (data.subType) {
                case ScheduleTaskEventStatus.idle:
                  return Text('媒体库同步暂停', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold));
                case ScheduleTaskEventStatus.update:
                  return Row(
                    spacing: 16,
                    children: [
                      const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 3)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .stretch,
                          spacing: 2,
                          children: [
                            Text('媒体库同步中', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold)),
                            Text('已同步 ${d[0]} 个文件', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  );
                case ScheduleTaskEventStatus.done:
                  return Column(
                    crossAxisAlignment: .stretch,
                    spacing: 2,
                    children: [
                      Text('媒体库同步完成', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold)),
                      Text('已同步 ${d[0]} 个文件', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  );
                case ScheduleTaskEventStatus.error:
                  return Column(
                    crossAxisAlignment: .stretch,
                    spacing: 2,
                    children: [
                      Text('媒体库同步失败', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold)),
                      Text('已同步 ${d[0]} 个文件', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  );
              }
            case ScheduleTaskEventType.scrapeLibrary:
              final d = data.data as List<dynamic>;
              switch (data.subType) {
                case ScheduleTaskEventStatus.idle:
                  return Text('媒体库刮削暂停', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold));
                case ScheduleTaskEventStatus.update:
                  return Row(
                    spacing: 16,
                    children: [
                      const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 3)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .stretch,
                          spacing: 2,
                          children: [
                            Text(
                              '媒体库刮削同步中',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold),
                            ),
                            Text('正在刮削 ${d[1]}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  );
                case ScheduleTaskEventStatus.done:
                  return Column(
                    crossAxisAlignment: .stretch,
                    spacing: 2,
                    children: [
                      Text('媒体库刮削完成', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold)),
                      Text('已刮削 ${d[0]} 个媒体', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  );
                case ScheduleTaskEventStatus.error:
                  return Column(
                    crossAxisAlignment: .stretch,
                    spacing: 2,
                    children: [
                      Text('媒体库刮削失败', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: .bold)),
                      Text('已刮削 ${d[0]} 个媒体', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  );
              }
          }
        },
      ),
    );
  }
}
