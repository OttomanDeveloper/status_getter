import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/views/status_saver/image/image_status_saver_view.dart';
import 'package:statusgetter/views/status_saver/video/video_status_saver_view.dart';

class WhatsAppItemCard extends StatelessWidget {
  final StatusItemModel item;
  const WhatsAppItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onTap: () {
            if (!item.isVideo) {
              Navigator.push<void>(context, CupertinoPageRoute(
                builder: (_) {
                  return ImageStatusSaverView(path: item.filePath.nullSafe);
                },
              ));
              return;
            } else {
              Navigator.push<void>(context, CupertinoPageRoute(
                builder: (_) {
                  return VideoStatusSaverView(path: item.filePath.nullSafe);
                },
              ));
              return;
            }
          },
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 0.7,
                color: context.theme.colorScheme.primary,
              ),
              image: !item.isVideo
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(item.filePath.nullSafe)),
                    )
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: <Widget>[
                if (item.isVideo)
                  Positioned.fill(
                    child: Image.memory(
                      fit: BoxFit.cover,
                      item.videoThumbnail!,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                Positioned(
                  top: constraints.maxHeight * 0.03,
                  right: constraints.maxWidth * 0.03,
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.theme.colorScheme.primary,
                    ),
                    child: Icon(
                      size: 20.0,
                      color: AppColors.kWhite,
                      item.isVideo ? Icons.play_circle_fill : Icons.image,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
