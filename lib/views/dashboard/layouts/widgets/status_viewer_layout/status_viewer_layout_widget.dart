import 'dart:io';
import 'package:flutter/material.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/item_card/item_card_widget.dart';

class StatusViewerLayoutWidget extends StatelessWidget {
  /// A [PageStorageKey] is used to uniquely identify a widget in the widget tree
  /// and preserve its scroll position when the widget is destroyed and recreated.
  /// It allows the widget to persist its state in [PageStorage] across page reloads,
  /// enabling the restoration of scroll position and other stateful information.
  final String pageStorageKey;
  final List<FileSystemEntity> files;
  const StatusViewerLayoutWidget({
    super.key,
    required this.files,
    required this.pageStorageKey,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: files.length,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      key: PageStorageKey<String>(pageStorageKey),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return WhatsAppItemCard(itemPath: files[index]);
      },
    );
  }
}
