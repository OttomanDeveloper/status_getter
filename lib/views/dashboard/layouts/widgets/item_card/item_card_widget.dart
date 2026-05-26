import 'dart:io';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/views/status_saver/image/image_status_saver_view.dart';
import 'package:statusgetter/views/status_saver/video/video_status_saver_view.dart';

class WhatsAppItemCard extends StatelessWidget {
  final StatusItemModel item;
  final int cacheWidth;
  final int cacheHeight;

  const WhatsAppItemCard({
    super.key,
    required this.item,
    required this.cacheWidth,
    required this.cacheHeight,
  });

  String get _heroTag => 'status_${item.filePath ?? item.safUri ?? ''}';

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.theme.colorScheme;

    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12.0),
      color: scheme.surfaceContainerHighest,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: _heroTag,
              child: _buildThumbnail(scheme),
            ),
            const _GradientScrim(),
            if (item.isVideo) const _PlayIndicator(),
            _TypeBadge(isVideo: item.isVideo, badgeColor: scheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(ColorScheme scheme) {
    if (item.isVideo && item.videoThumbnail != null) {
      return Image.memory(
        item.videoThumbnail!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }
    if (!item.isVideo) {
      return Image.file(
        File(item.filePath.nullSafe),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: (_, _, _) => Center(
          child: Icon(
            Icons.broken_image_rounded,
            size: 32.0,
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _onTap(BuildContext context) async {
    if (!item.isVideo) {
      Navigator.push<void>(
        context,
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, _, _) => ImageStatusSaverView(
            path: item.filePath.nullSafe,
            heroTag: _heroTag,
          ),
        ),
      );
      return;
    }

    String videoPath = item.filePath.nullSafe;
    if (videoPath.isEmpty && item.safUri != null) {
      try {
        final String fileName = Uri.decodeComponent(
          item.safUri!.split('%2F').last,
        );
        final String? cached = await WaUtils().copySafFileToCache(
          item.safUri!,
          fileName,
        );
        if (cached == null || !context.mounted) return;
        videoPath = cached;
      } catch (_) {
        return;
      }
    }
    if (!context.mounted) return;
    Navigator.push<void>(
      context,
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, _, _) => VideoStatusSaverView(
          path: videoPath,
          heroTag: _heroTag,
        ),
      ),
    );
  }
}

class _GradientScrim extends StatelessWidget {
  const _GradientScrim();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 60.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[AppColors.noColor, AppColors.kBlack],
          ),
        ),
      ),
    );
  }
}

class _PlayIndicator extends StatelessWidget {
  const _PlayIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.play_circle_filled_rounded,
        size: 44.0,
        color: AppColors.kWhite,
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final bool isVideo;
  final Color badgeColor;

  const _TypeBadge({required this.isVideo, required this.badgeColor});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8.0,
      bottom: 8.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              isVideo ? Icons.videocam_rounded : Icons.image,
              size: 14.0,
              color: AppColors.kWhite,
            ),
            const SizedBox(width: 4.0),
            Text(
              isVideo ? "Video" : "Photo",
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.kWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
