import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/ad_flow/widgets/banner_ad/banner_ad_widget.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/widgets/scaffold/scaffold_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoStatusSaverView extends StatefulWidget {
  final String path;
  final String heroTag;
  const VideoStatusSaverView({
    super.key,
    required this.path,
    required this.heroTag,
  });

  @override
  State<VideoStatusSaverView> createState() => _VideoStatusSaverViewState();
}

class _VideoStatusSaverViewState extends State<VideoStatusSaverView> {
  late final VideoPlayerController _videoController =
      VideoPlayerController.file(File(widget.path));

  ChewieController? _chewieController;
  bool _initialized = false;
  bool _saved = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        aspectRatio: _videoController.value.aspectRatio,
        autoPlay: true,
        looping: true,
        showControlsOnInitialize: false,
      );
      if (mounted) setState(() => _initialized = true);
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _chewieController?.pause();
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _save() {
    ImageGallerySaverPlus.saveFile(widget.path).then<void>((_) {
      AdManagerFunctions.instance.loadInterstitialAD();
      if (mounted) {
        setState(() => _saved = true);
        "Status Saved".showSnackbar(context);
      }
    });
  }

  void _share() {
    SharePlus.instance.share(ShareParams(files: [XFile(widget.path)]));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      useSafeArea: false,
      isScrollable: false,
      uiOverlay: AppThemes()
          .normalGB(context)
          .copyWith(statusBarColor: AppColors.noColor),
      appBar: AppBar(
        backgroundColor: AppColors.noColor,
        surfaceTintColor: AppColors.noColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.popNavigator(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          "Video",
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "save",
              onPressed: _saved ? null : _save,
              backgroundColor: _saved
                  ? Colors.green
                  : context.theme.colorScheme.primary,
              foregroundColor: AppColors.kWhite,
              icon: Icon(
                _saved ? Icons.check_rounded : Icons.download_rounded,
              ),
              label: Text(_saved ? "Saved" : "Save"),
            ),
            const SizedBox(width: 12.0),
            FloatingActionButton.extended(
              heroTag: "share",
              onPressed: _share,
              backgroundColor: context.theme.colorScheme.primary,
              foregroundColor: AppColors.kWhite,
              icon: const Icon(Icons.share_rounded),
              label: const Text("Share"),
            ),
          ],
        ),
      ),
      children: <Widget>[
        Expanded(child: _buildPlayer()),
        const BannerAdWidget(),
      ],
    );
  }

  Widget _buildPlayer() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              size: 48.0,
              color: context.textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 12.0),
            Text(
              "Unable to play this video.",
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (!_initialized || _chewieController == null) {
      return Center(
        child: Hero(
          tag: widget.heroTag,
          child: const CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Chewie(controller: _chewieController!);
  }
}
