import 'package:flutter/foundation.dart';

@immutable
final class SafFileInfo {
  final String name;
  final String uri;
  final String mimeType;
  final int size;
  final int lastModified;

  const SafFileInfo({
    required this.name,
    required this.uri,
    required this.mimeType,
    required this.size,
    required this.lastModified,
  });

  bool get isVideo => name.toLowerCase().endsWith('.mp4');
  bool get isImage {
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  factory SafFileInfo.fromMap(Map<Object?, Object?> map) {
    return SafFileInfo(
      name: map['name'] as String? ?? '',
      uri: map['uri'] as String? ?? '',
      mimeType: map['mimeType'] as String? ?? '',
      size: map['size'] as int? ?? 0,
      lastModified: map['lastModified'] as int? ?? 0,
    );
  }
}
