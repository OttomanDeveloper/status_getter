import 'package:flutter/foundation.dart';

@immutable
final class StatusItemModel {
  final bool isVideo;
  final String? filePath;
  final Uint8List? videoThumbnail;

  const StatusItemModel({
    this.filePath,
    this.videoThumbnail,
    this.isVideo = false,
  });

  StatusItemModel copyWith({
    bool? isVideo,
    String? filePath,
    Uint8List? videoThumbnail,
  }) {
    return StatusItemModel(
      isVideo: isVideo ?? this.isVideo,
      filePath: filePath ?? this.filePath,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
    );
  }

  @override
  bool operator ==(covariant StatusItemModel other) {
    if (identical(this, other)) return true;

    return other.isVideo == isVideo &&
        other.filePath == filePath &&
        other.videoThumbnail == videoThumbnail;
  }

  @override
  int get hashCode =>
      isVideo.hashCode ^ filePath.hashCode ^ videoThumbnail.hashCode;

  @override
  String toString() =>
      'StatusItemModel(isVideo: $isVideo, filePath: $filePath, videoThumbnail: $videoThumbnail)';
}
