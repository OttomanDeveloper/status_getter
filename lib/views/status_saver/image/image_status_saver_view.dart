import 'dart:io';

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

class ImageStatusSaverView extends StatefulWidget {
  final String path;
  final String heroTag;
  const ImageStatusSaverView({
    super.key,
    required this.path,
    required this.heroTag,
  });

  @override
  State<ImageStatusSaverView> createState() => _ImageStatusSaverViewState();
}

class _ImageStatusSaverViewState extends State<ImageStatusSaverView> {
  bool _saved = false;

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
      extendBody: true,
      useSafeArea: false,
      isScrollable: false,
      isStack: true,
      fit: StackFit.expand,
      uiOverlay: AppThemes()
          .normalGB(context)
          .copyWith(statusBarColor: AppColors.noColor),
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
              icon: Icon(_saved ? Icons.check_rounded : Icons.download_rounded),
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
        // Image with Hero
        Positioned.fill(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: widget.heroTag,
                child: Image.file(
                  File(widget.path),
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.broken_image_rounded,
                        size: 48.0,
                        color: context.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        "This status is no longer available.",
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Back button
        Positioned(
          top: MediaQuery.paddingOf(context).top + 8.0,
          left: 4.0,
          child: IconButton(
            onPressed: () => context.popNavigator(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: context.textTheme.bodyLarge?.color,
          ),
        ),

        // Banner ad at bottom
        const Positioned(
          bottom: 80.0,
          left: 0,
          right: 0,
          child: BannerAdWidget(),
        ),
      ],
    );
  }
}
