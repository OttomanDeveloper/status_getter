import 'package:flutter/material.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/item_card/item_card_widget.dart';

class StatusViewerLayoutWidget extends StatelessWidget {
  final String pageStorageKey;
  final List<StatusItemModel> files;
  const StatusViewerLayoutWidget({
    super.key,
    required this.files,
    required this.pageStorageKey,
  });

  static const int _crossAxisCount = 2;
  static const double _spacing = 10.0;
  static const double _padding = 10.0;
  static const double _aspectRatio = 0.75;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double cardWidth =
        (screenWidth - (_padding * 2) - (_spacing * (_crossAxisCount - 1))) /
            _crossAxisCount;
    final double cardHeight = cardWidth / _aspectRatio;
    final int cacheW = cardWidth.toInt();
    final int cacheH = cardHeight.toInt();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
        childAspectRatio: _aspectRatio,
      ),
      itemCount: files.length,
      padding: const EdgeInsets.all(_padding),
      key: PageStorageKey<String>(pageStorageKey),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemBuilder: (BuildContext context, int index) {
        return WhatsAppItemCard(
          item: files[index],
          cacheWidth: cacheW,
          cacheHeight: cacheH,
        );
      },
    );
  }
}
