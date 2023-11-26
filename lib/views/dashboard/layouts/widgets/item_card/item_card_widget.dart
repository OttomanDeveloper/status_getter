import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/views/status_saver/image/image_status_saver_view.dart';
import 'package:statusgetter/views/status_saver/video/video_status_saver_view.dart';

class WhatsAppItemCard extends StatelessWidget {
  final FileSystemEntity itemPath;
  const WhatsAppItemCard({super.key, required this.itemPath});

  @override
  Widget build(BuildContext context) {
    final bool isImage = itemPath.path.endsWith(".jpg");
    if (isImage) {
      return _getThumbnail(
        isImage: isImage,
        context: context,
        path: itemPath.path,
        videoPath: AppSettings.empty,
      );
    } else {
      return FutureBuilder<String>(
        future: WaUtils().getThumbnail(itemPath.path),
        builder: (_, AsyncSnapshot<String> snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasData && snap.data.isNotEmpty) {
            return _getThumbnail(
              isImage: isImage,
              context: context,
              path: snap.data.nullSafe,
              videoPath: itemPath.path,
            );
          } else {
            return const Center(child: Icon(Icons.info));
          }
        },
      );
    }
  }

  Widget _getThumbnail({
    required String path,
    required bool isImage,
    required String videoPath,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isImage) {
          return Navigator.push<void>(
            context,
            CupertinoPageRoute(
              builder: (_) => ImageStatusSaverView(path: path),
            ),
          );
        } else {
          return Navigator.push<void>(
            context,
            CupertinoPageRoute(
              builder: (_) => VideoStatusSaverView(path: videoPath),
            ),
          );
        }
      },
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              border: Border.all(
                width: 0.5,
                color: context.theme.colorScheme.primary,
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(path)),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: <Widget>[
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
                      isImage ? Icons.image : Icons.play_circle_fill,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
