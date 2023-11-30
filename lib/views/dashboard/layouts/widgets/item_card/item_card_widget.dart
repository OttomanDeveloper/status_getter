import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/views/status_saver/image/image_status_saver_view.dart';
import 'package:statusgetter/views/status_saver/video/video_status_saver_view.dart';

class WhatsAppItemCard extends StatelessWidget {
  final FileSystemEntity itemPath;
  const WhatsAppItemCard({super.key, required this.itemPath});

  @override
  Widget build(BuildContext context) {
    final bool isImage = itemPath.path.endsWith(".jpg");
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onTap: () {
            if (isImage) {
              Navigator.push<void>(context, CupertinoPageRoute(
                builder: (_) {
                  return ImageStatusSaverView(path: itemPath.path);
                },
              ));
              return;
            } else {
              Navigator.push<void>(context, CupertinoPageRoute(
                builder: (_) {
                  return VideoStatusSaverView(path: itemPath.path);
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
              image: isImage
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(itemPath.path)),
                    )
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: <Widget>[
                if (!isImage)
                  Positioned.fill(
                    child: FutureBuilder<Uint8List?>(
                      future: WaUtils().getThumbnail(itemPath.path),
                      builder: (_, AsyncSnapshot<Uint8List?> s) {
                        if (s.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (s.hasData && s.data != null) {
                          return Image.memory(
                            fit: BoxFit.cover,
                            s.data!,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                          );
                        } else {
                          return const Center(
                            child: Icon(Icons.info),
                          );
                        }
                      },
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
                      isImage ? Icons.image : Icons.play_circle_fill,
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
