import 'package:flutter/foundation.dart';

@immutable
final class StatusItemModel {
  final bool isVideo;
  final String? filePath;
  final String? safUri;
  final Uint8List? videoThumbnail;

  const StatusItemModel({
    this.filePath,
    this.safUri,
    this.videoThumbnail,
    this.isVideo = false,
  });

  StatusItemModel copyWith({
    bool? isVideo,
    String? filePath,
    String? safUri,
    Uint8List? videoThumbnail,
  }) {
    return StatusItemModel(
      isVideo: isVideo ?? this.isVideo,
      filePath: filePath ?? this.filePath,
      safUri: safUri ?? this.safUri,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
    );
  }

  @override
  bool operator ==(covariant StatusItemModel other) {
    if (identical(this, other)) return true;

    return other.isVideo == isVideo &&
        other.filePath == filePath &&
        other.safUri == safUri &&
        other.videoThumbnail == videoThumbnail;
  }

  @override
  int get hashCode =>
      isVideo.hashCode ^
      filePath.hashCode ^
      safUri.hashCode ^
      videoThumbnail.hashCode;

  @override
  String toString() =>
      'StatusItemModel(isVideo: $isVideo, filePath: $filePath, safUri: $safUri, videoThumbnail: $videoThumbnail)';
}
