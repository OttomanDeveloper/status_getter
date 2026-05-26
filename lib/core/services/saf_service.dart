import 'package:flutter/services.dart';
import 'package:statusgetter/core/model/saf_file_info/saf_file_info_model.dart';

class SafService {
  static const MethodChannel _channel = MethodChannel(
    'com.androidsaver.statusgetter/saf',
  );

  Future<({bool granted, String? treeUri})> checkPermission(
    String relativePath,
  ) async {
    final Map<Object?, Object?> result =
        await _channel.invokeMethod('checkPermission', {'path': relativePath});
    final bool granted = result['granted'] as bool? ?? false;
    final String? treeUri = result['treeUri'] as String?;
    return (granted: granted, treeUri: treeUri);
  }

  Future<String?> requestPermission(String relativePath) {
    return _channel.invokeMethod<String>(
      'requestPermission',
      {'path': relativePath},
    );
  }

  Future<List<SafFileInfo>> listFiles(String treeUri) async {
    final result = await _channel.invokeMethod<List<Object?>>(
      'listFiles',
      {'treeUri': treeUri},
    );
    if (result == null) return <SafFileInfo>[];
    return result
        .whereType<Map<Object?, Object?>>()
        .map(SafFileInfo.fromMap)
        .toList();
  }

  Future<String?> copyToCache(String uri, String fileName) {
    return _channel.invokeMethod<String>(
      'copyToCache',
      {'uri': uri, 'fileName': fileName},
    );
  }

  Future<Uint8List?> getThumbnailFromUri(String uri) {
    return _channel.invokeMethod<Uint8List>(
      'getThumbnailFromUri',
      {'uri': uri},
    );
  }

  Future<void> releasePermission(String treeUri) {
    return _channel.invokeMethod('releasePermission', {'treeUri': treeUri});
  }

  Future<void> clearCache() {
    return _channel.invokeMethod('clearCache');
  }
}
