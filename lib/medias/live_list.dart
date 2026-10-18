import 'dart:async';

import 'package:api/api.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:rxdart/rxdart.dart';

import '../../components/components.dart';
import '../../menus/playlist.dart';
import '../../utils/utils.dart';
import '../adaptive/adaptive.dart';
import '../extensions/extensions.dart';

class LiveListPage extends StatefulWidget {
  const LiveListPage({super.key});

  @override
  State<LiveListPage> createState() => _LiveListPageState();
}

class _LiveListPageState extends State<LiveListPage> with WidgetsBindingObserver {
  StreamSubscription<EventData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = MergeStream([EventDispatcher.where(type: .playlist).doOnData((_) => setState(() {}))])
        .listen((_) {});
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilderHandler<List<Playlist>>(
          future: Api.playlistQueryAll(),
          builder: (context, snapshot) {
            return snapshot.requireData.isNotEmpty
                ? Padding(
                    padding: theme.channelsContentPadding,
                    child: _LiveList(
                      items: snapshot.requireData,
                      onTap: (item) => context.pushNamed(.liveDetail, arguments: item),
                    ),
                  )
                : NoData(
                    action: IconButton.filledTonal(
                      onPressed: () => context.pushNamed(.liveEdit),
                      autofocus: true,
                      icon: const Icon(Icons.add),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class _LiveList extends StatefulWidget {
  const _LiveList({required this.items, this.onSelected, this.onTap});

  final List<Playlist> items;
  final PopupMenuItemSelected<Playlist>? onSelected;
  final PopupMenuItemSelected<Playlist>? onTap;

  @override
  State<_LiveList> createState() => _LiveListState();
}

class _LiveListState extends State<_LiveList> {
  late int? _selectedPlaylistId = widget.items.firstOrNull?.id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onSelected != null) {
        final Playlist? item = widget.items.firstWhereOrNull((item) => _selectedPlaylistId == item.id);
        if (item != null) {
          widget.onSelected!(item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    final child = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: theme.channelsListViewPadding,
          sliver: SliverList.separated(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final Playlist item = widget.items[index];
              return ActionListTile(
                selected: widget.onSelected != null && _selectedPlaylistId == item.id,
                autofocus: index == 0,
                title: item.title == null ? null : Text(item.title!, overflow: TextOverflow.ellipsis),
                subtitle: Text(item.url, overflow: TextOverflow.ellipsis),
                onTap: () {
                  if (widget.onSelected != null && _selectedPlaylistId != item.id) {
                    setState(() => _selectedPlaylistId = item.id);
                    widget.onSelected!(item);
                  }
                  widget.onTap?.call(item);
                },
                actionSide: ActionSide.start,
                actions: PlaylistMenu(item),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 4),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + theme.channelsListViewPadding.bottom,
          ),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton.filledTonal(
                  onPressed: () => context.pushNamed(.liveEdit),
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    return child;
  }
}
