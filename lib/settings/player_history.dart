import 'package:api/api.dart';
import 'package:flutter/material.dart' hide ListTile;

import '../../components/components.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';

class SystemSettingsPlayerHistory extends StatefulWidget {
  const SystemSettingsPlayerHistory({super.key});

  @override
  State<SystemSettingsPlayerHistory> createState() => _SystemSettingsPlayerHistoryState();
}

class _SystemSettingsPlayerHistoryState extends State<SystemSettingsPlayerHistory> {
  @override
  Widget build(BuildContext context) {
    return SettingPage(
      title: Text(AppLocalizations.of(context)!.settingsItemPlayerHistory),
      child: FutureBuilderHandler(
        future: Api.playerHistory(),
        builder: (context, snapshot) {
          return snapshot.requireData.isEmpty
              ? const NoData()
              : ListView.builder(
                  padding: SettingPageTheme.of(context).contentPadding,
                  itemBuilder: (context, index) {
                    final PlayerHistory item = snapshot.requireData[index];
                    return ListTile(
                      leading: item.poster != null
                          ? AsyncImage(item.poster!, width: 48, radius: const BorderRadius.all(Radius.circular(4)))
                          : AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                ),
                                child: const Icon(Icons.image_not_supported_outlined, size: 24),
                              ),
                            ),
                      title: Text(item.title, overflow: TextOverflow.ellipsis, maxLines: 2),
                      trailing: item.duration > Duration.zero
                          ? SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                value: item.lastPlayedPosition.inMilliseconds / item.duration.inMilliseconds,
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              ),
                            )
                          : null,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.labelSmall,
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .timeAgo(item.lastPlayedTime.fromNow().fromNowFormat(context)),
                                  ),
                                  const WidgetSpan(child: Gap.hLG),
                                  TextSpan(text: item.lastPlayedPosition.toDisplay()),
                                  const TextSpan(text: ' / '),
                                  TextSpan(text: item.duration.toDisplay()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        switch (item.mediaType) {
                          case MediaType.movie:
                            await toMediaPlayer(context, .movie, item.id);
                          case MediaType.episode:
                            await toMediaPlayer(context, .episode, item.id);
                          default:
                        }
                      },
                    );
                  },
                  itemCount: snapshot.requireData.length,
                );
        },
      ),
    );
  }
}
