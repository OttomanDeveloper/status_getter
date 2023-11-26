import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/ad_flow/widgets/banner_ad/banner_ad_widget.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/widgets/scaffold/scaffold_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoStatusSaverView extends StatefulWidget {
  final String path;
  const VideoStatusSaverView({super.key, required this.path});

  @override
  State<VideoStatusSaverView> createState() => _VideoStatusSaverViewState();
}

class _VideoStatusSaverViewState extends State<VideoStatusSaverView> {
  /// Create an Instance of `Size`
  late final Size size = context.sizeApi;

  /// Create a List of Floating Action Buttons
  final List<Widget> floatingButtons = const <Widget>[
    Icon(Icons.download),
    Icon(Icons.share),
  ];

  /// Create an Instance of `ChewieController`
  late final ChewieController _chewieController = ChewieController(
    looping: true,
    autoPlay: true,
    aspectRatio: (5 / 6),
    errorBuilder: (_, String error) {
      return Center(child: Text(error));
    },
    videoPlayerController: VideoPlayerController.file(File(widget.path)),
  );

  @override
  void dispose() {
    _chewieController.pause();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      uiOverlay: AppThemes().normalGB(context).copyWith(
            statusBarColor: AppColors.noColor,
          ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List<Widget>.generate(
          floatingButtons.length,
          (int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton(
                heroTag: "$index",
                clipBehavior: Clip.antiAliasWithSaveLayer,
                onPressed: () async {
                  switch (index) {
                    case 0:
                      "download image".print();
                      ImageGallerySaver.saveFile(widget.path).then<void>((_) {
                        AdManagerFunctions.instance.loadInterstitialAD();
                        "Status Saved".showSnackbar(context);
                      });
                      break;
                    case 1:
                      "Share".print();
                      Share.shareXFiles([XFile(widget.path)]);
                      break;
                  }
                },
                child: floatingButtons.elementAt(index),
              ),
            );
          },
        ),
      ),
      children: <Widget>[
        Expanded(child: Chewie(controller: _chewieController)),
        const BannerAdWidget(),
      ],
    );
  }
}
