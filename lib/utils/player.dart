import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';
import 'utils.dart';

Future<void> toMediaPlayer<T extends MediaBase>(BuildContext context, MediaType type, dynamic id) {
  return Navigator.of(context, rootNavigator: true).push<T>(
    MaterialPageRoute(
      builder: (context) => _PlayerPreparePage(type: type, id: id),
    ),
  );
}

class _PlayerPreparePage extends StatelessWidget {
  const _PlayerPreparePage({required this.type, required this.id});

  final MediaType type;
  final dynamic id;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      child: Scaffold(
        appBar: AppBar(forceMaterialTransparency: true, automaticallyImplyLeading: false),
        extendBodyBehindAppBar: true,
        body: FutureBuilderHandler(
          future: getPlaylistById(type, id),
          builder: (context, snapshot) {
            Future.microtask(() {
              if (context.mounted) {
                context.pushReplacementNamed(.player, arguments: snapshot.requireData);
              }
            });
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
