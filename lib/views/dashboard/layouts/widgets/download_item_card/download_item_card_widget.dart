import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/domain/model/site_model.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';

enum _DownloadStatus { idle, downloading, completed, failed }

class DownloadItemCard extends StatefulWidget {
  final String? title;
  final LinkModel links;
  final String? duration;
  final String? thumbnail;

  const DownloadItemCard({
    super.key,
    this.title,
    this.duration,
    this.thumbnail,
    required this.links,
  });

  @override
  State<DownloadItemCard> createState() => _DownloadItemCardState();
}

class _DownloadItemCardState extends State<DownloadItemCard> {
  _DownloadStatus _status = _DownloadStatus.idle;
  double _progress = 0.0;

  Future<void> _startDownload() async {
    if (_status == _DownloadStatus.downloading) return;

    setState(() {
      _status = _DownloadStatus.downloading;
      _progress = 0.0;
    });

    AdManagerFunctions.instance.loadInterstitialAD();

    await FileDownloader.downloadFile(
      url: widget.links.link.nullSafe.trim(),
      notificationType: NotificationType.all,
      downloadDestination: DownloadDestinations.publicDownloads,
      name: "${DateTime.now().microsecondsSinceEpoch}.mp4",
      onProgress: (String? fileName, double? progress) {
        if (mounted && progress != null) {
          setState(() => _progress = progress / 100.0);
        }
      },
      onDownloadCompleted: (String path) {
        if (mounted) {
          setState(() => _status = _DownloadStatus.completed);
          "Download complete".showSnackbar(context);
        }
      },
      onDownloadError: (String error) {
        if (mounted) {
          setState(() => _status = _DownloadStatus.failed);
          "Download failed".showSnackbar(context);
        }
      },
    ).then((File? value) => null);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Thumbnail
              if (widget.thumbnail.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14.0),
                  ),
                  child: Image.network(
                    widget.thumbnail.nullSafe,
                    width: 90.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 90.0,
                      height: 100.0,
                      color: scheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.videocam_rounded,
                        color: context.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (widget.title.isNotEmpty)
                        AutoSizeText(
                          widget.title.nullSafe,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: <Widget>[
                          if (widget.links.quality.isNotEmpty)
                            _InfoChip(
                              label: widget.links.quality,
                              color: scheme.primary,
                            ),
                          if (widget.links.quality.isNotEmpty &&
                              widget.links.type.isNotEmpty)
                            const SizedBox(width: 6.0),
                          if (widget.links.type.isNotEmpty)
                            _InfoChip(
                              label: widget.links.type.nullSafe,
                              color: scheme.tertiary,
                            ),
                          if (widget.duration.isNotEmpty) ...[
                            const SizedBox(width: 6.0),
                            _InfoChip(
                              label: widget.duration.nullSafe,
                              color: scheme.secondary,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Download button
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: _buildActionButton(scheme),
              ),
            ],
          ),

          if (_status == _DownloadStatus.downloading)
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Downloading...",
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.textTheme.bodySmall?.color,
                        ),
                      ),
                      Text(
                        _progress > 0
                            ? "${(_progress * 100).toInt()}%"
                            : "Preparing...",
                        style: context.textTheme.labelSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LinearProgressIndicator(
                      value: _progress > 0 ? _progress : null,
                      minHeight: 4.0,
                      backgroundColor:
                          scheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        scheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ColorScheme scheme) {
    switch (_status) {
      case _DownloadStatus.completed:
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            size: 20.0,
            color: Colors.green,
          ),
        );

      case _DownloadStatus.failed:
        return Material(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: _startDownload,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.refresh_rounded,
                size: 20.0,
                color: Colors.red,
              ),
            ),
          ),
        );

      case _DownloadStatus.downloading:
        return SizedBox(
          width: 28.0,
          height: 28.0,
          child: CircularProgressIndicator(
            value: _progress > 0 ? _progress : null,
            strokeWidth: 2.5,
            color: scheme.primary,
          ),
        );

      case _DownloadStatus.idle:
        return Material(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: _startDownload,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.download_rounded,
                size: 20.0,
                color: AppColors.kWhite,
              ),
            ),
          ),
        );
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
