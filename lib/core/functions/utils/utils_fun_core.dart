import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/model/saf_file_info/saf_file_info_model.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';
import 'package:statusgetter/core/services/saf_service.dart';

class WaUtils {
  /// Create an Instance
  static WaUtils? _instance;

  /// Privatised the constructor
  WaUtils._internal() {
    "WaUtils constructor called".print();
  }

  /// Provide a instance whenever it's needed
  factory WaUtils() {
    // Provide a instance if not initialized yet
    _instance ??= WaUtils._internal();
    return _instance!;
  }

  /// Create an Instance of `DeviceInfoPlugin`
  final DeviceInfoPlugin _dInfo = DeviceInfoPlugin();

  /// Hold `AndroidDeviceInfo`
  AndroidDeviceInfo? get androidInfo => _androidInfo;
  AndroidDeviceInfo? _androidInfo;

  /// SAF service for Android 11+ (SDK >= 30)
  late final SafService _safService = SafService();

  /// SAF relative paths — used by both BLoCs via WaUtils, defined once here
  static const String whatsAppSafPath =
      'Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
  static const String whatsAppBusinessSafPath =
      'Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';

  Future<void> getDeviceInfo() async {
    try {
      _androidInfo ??= await _dInfo.androidInfo;
      return;
    } on PlatformException catch (e) {
      return e.message?.print("getDeviceInfo Error:");
    }
  }

  /// Whether to use SAF instead of direct filesystem access (Android 11+, SDK >= 30).
  /// Call ensureDeviceInfo() before using this in async contexts.
  bool get useSaf {
    return (_androidInfo != null) && (_androidInfo!.version.sdkInt >= 30);
  }

  /// Whether WhatsApp uses the modern storage path (Android/media/com.whatsapp/...).
  /// True on SDK >= 29 (Android 10+). This is separate from useSaf because:
  /// - SDK 29 (Android 10): modern PATH but legacy PERMISSION (requestLegacyExternalStorage)
  /// - SDK >= 30 (Android 11+): modern PATH and SAF PERMISSION
  /// - SDK < 29: legacy PATH and legacy PERMISSION
  bool get _useModernPath {
    return (_androidInfo != null) && (_androidInfo!.version.sdkInt >= 29);
  }

  /// Ensure device info is loaded before checking useSaf.
  Future<void> ensureDeviceInfo() async {
    if (_androidInfo == null) await getDeviceInfo();
  }

  /// Legacy storage permission for SDK < 30.
  Future<PermissionStatus> get askLegacyStoragePermission {
    return Permission.storage.request();
  }

  /// Check if SAF permission is already granted. Returns tree URI if granted.
  Future<String?> checkSafPermission(String relativePath) async {
    final result = await _safService.checkPermission(relativePath);
    return result.granted ? result.treeUri : null;
  }

  /// Open the SAF folder picker. Returns granted tree URI, or null if cancelled.
  Future<String?> requestSafPermission(String relativePath) {
    return _safService.requestPermission(relativePath);
  }

  /// Fetch statuses via SAF — shared by both WhatsappBloc and BusinessWhatsAppBloc.
  Future<List<StatusItemModel>?> fetchStatusesViaSaf(String treeUri) async {
    try {
      await _safService.clearCache();

      final List<SafFileInfo> files = await _safService.listFiles(treeUri);
      if (files.isEmpty) return null;

      final List<StatusItemModel> items = <StatusItemModel>[];
      for (final SafFileInfo file in files) {
        if (file.isImage) {
          final String? cachePath =
              await _safService.copyToCache(file.uri, file.name);
          if (cachePath != null) {
            items.add(StatusItemModel(filePath: cachePath, isVideo: false));
          }
        } else if (file.isVideo) {
          final Uint8List? thumbnail =
              await _safService.getThumbnailFromUri(file.uri);
          items.add(StatusItemModel(
            isVideo: true,
            safUri: file.uri,
            videoThumbnail: thumbnail,
          ));
        }
      }
      return items.isEmpty ? null : items;
    } catch (e) {
      e.toString().print("fetchStatusesViaSaf Error:");
      return null;
    }
  }

  /// Copy a single SAF file to cache — used for on-demand video caching.
  Future<String?> copySafFileToCache(String uri, String fileName) {
    return _safService.copyToCache(uri, fileName);
  }

  /// Create an Instance of `WaPathGeneratorUtil`
  late final WaPathGeneratorUtil _waPathGeneratorUtil = WaPathGeneratorUtil();

  /// Provide the path for WhatsApp Status (direct filesystem, SDK < 30 only).
  /// Uses _useModernPath (SDK >= 29) for path selection — WhatsApp moved storage on Android 10.
  Future<String> get whatsAppPath async {
    final String? path =
        await _waPathGeneratorUtil.whatsAppPath(_useModernPath);

    if (path.nullSafe.isNotEmpty) {
      return path.nullSafe;
    } else if (_useModernPath) {
      return "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
    } else {
      return "/storage/emulated/0/WhatsApp/Media/.Statuses";
    }
  }

  /// Provide the path for WhatsApp Business Status (direct filesystem, SDK < 30 only).
  Future<String> get whatsAppBusinessPath async {
    final String? path =
        await _waPathGeneratorUtil.businessWaPath(_useModernPath);

    if (path.nullSafe.isNotEmpty) {
      return path.nullSafe;
    } else if (_useModernPath) {
      return "/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";
    } else {
      return "/storage/emulated/0/WhatsApp Business/Media/.Statuses";
    }
  }

  /// Thumbnail Getter `MethodChannel` Name
  final MethodChannel _channelId = const MethodChannel(
    "com.androidsaver.statusgetter/ottomancoder",
  );

  ///  Thumbnail Method ID
  final String _methodId = "thumbnail";

  /// Get `Thumbnail` from `Video`.
  ///
  /// This function retrieves a thumbnail image from a video file. It first checks
  /// if the platform is Android, and if so, it attempts to use a native method
  /// (_videoToThumbnailIsolate) to fetch the thumbnail. Otherwise, it falls back
  /// to using the VideoThumbnail plugin for other platforms.
  ///
  /// Parameters:
  /// - `path`: The path to the video file from which to generate the thumbnail.
  ///
  /// Returns:
  /// A `Future` that resolves to a `Uint8List` containing the thumbnail image
  /// data, or `null` if an error occurs.
  Future<Uint8List?> getThumbnail(String path) {
    try {
      return _videoToThumbnailIsolate(
        videoPath: path,
        method: _methodId,
        channel: _channelId,
        token: RootIsolateToken.instance,
      );
    } catch (e) {
      e.toString().print("getThumbnail Error:");
      return Future<Uint8List?>.value(null);
    }
  }
}

@immutable
final class WaPathGeneratorUtil {
  /// Create an Instance
  static WaPathGeneratorUtil? _instance;

  /// Privatised the constructor
  WaPathGeneratorUtil._internal() {
    "WaPathGeneratorUtil constructor called".print();
  }

  /// Provide a instance whenever it's needed
  factory WaPathGeneratorUtil() {
    // Provide a instance if not initialized yet
    _instance ??= WaPathGeneratorUtil._internal();
    return _instance!;
  }

  /// This asynchronous function retrieves the Android external storage directory path.
  /// It is designed to work with Android, and it's part of a path generation utility.
  ///
  /// The steps include:
  /// 1. Retrieve the external storage directory path using `getExternalStorageDirectory()`.
  /// 2. Print the raw path for debugging purposes.
  /// 3. Check if the directory is not null.
  /// 4. Convert the directory path into a list of strings.
  /// 5. Extract the desired path by removing unnecessary parts (from root to "Android").
  /// 6. Return the modified directory path.
  ///
  /// If any error occurs during this process, it will be caught and printed.
  /// The function returns a `Future<String?>`, where the String is the Android path or null if there's an error.
  Future<String?> _getAndroidPath() async {
    try {
      // Step 1: Get External Storage Directory Path
      Directory? directory = await getExternalStorageDirectory();
      directory?.path.print("_getAndroidPath - RawPath");

      // Step 2: Make sure directory is not null
      if (directory != null) {
        // Step 3: Convert directory path into List
        final List<String> paths = directory.path.split("/");

        // Step 4: Extract the desired path by removing unnecessary parts (from root to "Android")
        final String newPath =
            paths.sublist(1, paths.indexOf("Android")).join("/");
        directory = Directory(newPath);

        // Step 5: Return the modified directory path
        return directory.path;
      }
    } catch (e) {
      // Step 6: Print any error that occurs during the process
      e.toString().print("WaPathGeneratorUtil _getAndroidPath Error:");
    }
    return null;
  }

  /// Obtain the Business WhatsApp path in a more dynamic way.
  Future<String?> businessWaPath(bool isModernPath) {
    return _getAndroidPath().then<String?>((String? rawPath) {
      // Check if rawPath is not null then joins the path. Otherwise return null.
      if (rawPath.nullSafe.isNotEmpty) {
        if (isModernPath) {
          return "$rawPath$_businessWaModernPath";
        } else {
          return "$rawPath$_businessWaLegacyPath";
        }
      } else {
        return null;
      }
    });
  }

  /// Obtain the WhatsApp path in a more dynamic way.
  Future<String?> whatsAppPath(bool isModernPath) {
    return _getAndroidPath().then<String?>((String? rawPath) {
      // Check if rawPath is not null then joins the path. Otherwise return null.
      if (rawPath.nullSafe.isNotEmpty) {
        if (isModernPath) {
          return "$rawPath$_whatsAppModernPath";
        } else {
          return "$rawPath$_whatsAppLegacyPath";
        }
      } else {
        return null;
      }
    });
  }

  /// WhatsApp Business Path for Latest Android Versions Above Android 10+
  final String _businessWaModernPath =
      "/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";

  /// Represents the path for WhatsApp Business on Android devices running versions older than Android 10.
  final String _businessWaLegacyPath = "/WhatsApp Business/Media/.Statuses";

  /// WhatsApp Path for Latest Android Versions Above Android 10+
  final String _whatsAppModernPath =
      "/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";

  /// Represents the path for WhatsApp on Android devices running versions older than Android 10.
  final String _whatsAppLegacyPath = "/WhatsApp/Media/.Statuses";
}

/// Get Video Thumbnail Image in `Android` Side Using `Isolate`
/// This function is used to retrieve a video thumbnail image on the Android side using Isolate.
/// Isolate is a separate Dart execution context, and using it helps in offloading tasks from the main UI thread.
Future<Uint8List?> _videoToThumbnailIsolate({
  int? quality,
  required String method,
  required String videoPath,
  required MethodChannel channel,
  required RootIsolateToken? token,
}) {
  return Isolate.run<Uint8List?>(() async {
    // if Root Isolate Token is not null then bind it
    if (token != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      DartPluginRegistrant.ensureInitialized();
    }

    // Now Try to get video thumbnail
    try {
      /// Check if call sent from the supported platform (Android in this case)
      if (Platform.isAndroid) {
        /// Invoke or call MethodChannel
        final data = await channel.invokeMethod(
          method,
          <String, dynamic>{'path': videoPath, 'quality': quality},
        );

        // Check if response is not null and data type is `Uint8List`
        if (data != null && data is Uint8List) {
          "Thumbnail Getter Successfully".print("_videoToThumbnail");
          return data;
        }
      }
    } on PlatformException catch (e) {
      // Handle any platform-specific exceptions
      e.message.toString().print("_videoToThumbnail Error");
    }

    // Return null because the platform is not supported or image failed to compress
    return null;
  }).catchError((_) => null);
}
