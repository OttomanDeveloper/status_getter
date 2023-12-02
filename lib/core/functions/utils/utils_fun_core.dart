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
import 'package:video_thumbnail/video_thumbnail.dart';

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

  /// Get Android Device Info
  /// This function initializes the `_dInfo` plugin and retrieves information about the Android device.
  /// If the information has not been retrieved before, it stores the result in `_androidInfo`.
  /// If the information has already been retrieved, it returns the stored information.
  /// This is an asynchronous operation, so it returns a Future.
  /// In case of any exceptions, it catches a `PlatformException` and prints an error message.
  Future<void> getDeviceInfo() async {
    try {
      _androidInfo ??= await _dInfo.androidInfo;
      return;
    } on PlatformException catch (e) {
      return e.message?.print("getDeviceInfo Error:");
    }
  }

  /// Ask for Storage Permissions to Get Status from User Device.
  Future<PermissionStatus> get askStoragePermission {
    // Check if we need to ask for ManageExternal Permission or normal Read & Write
    if (shouldAskManageExternalPermission) {
      return Permission.manageExternalStorage.request();
    } else {
      return Permission.storage.request();
    }
  }

  /// The `shouldAskManageExternalPermission` function determines whether the app should request
  /// the "MANAGE_EXTERNAL_STORAGE" permission, which is required for accessing media files
  /// on Android devices with version 10 (SDK version 29) or higher.
  /// It returns `true` if the conditions for requiring the permission are met, and `false` otherwise.
  bool get shouldAskManageExternalPermission {
    // Check if Android device information is not available, then get Device info.
    if (_androidInfo == null) {
      getDeviceInfo();
    }

    // Return `true` if Android information is available and the SDK version is 29 or higher.
    return ((_androidInfo != null) && (_androidInfo!.version.sdkInt >= 29));
  }

  /// Create an Instance of `WaPathGeneratorUtil`
  late final WaPathGeneratorUtil _waPathGeneratorUtil = WaPathGeneratorUtil();

  /// Provide the path for `WhatsApp Status` based on the app's permission to manage external storage.
  Future<String> get whatsAppPath async {
    final String? path = await _waPathGeneratorUtil
        .whatsAppPath(shouldAskManageExternalPermission);

    // Return the obtained path if not empty; otherwise, fallback to default paths based on permission.
    if (path.nullSafe.isNotEmpty) {
      return path.nullSafe;
    } else if (shouldAskManageExternalPermission) {
      return "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
    } else {
      return "/storage/emulated/0/WhatsApp/Media/.Statuses";
    }
  }

  /// Provide the path for `WhatsApp Business Status` based on the app's permission to manage external storage.
  Future<String> get whatsAppBusinessPath async {
    final String? path = await _waPathGeneratorUtil
        .businessWaPath(shouldAskManageExternalPermission);

    // Return the obtained path if not empty; otherwise, fallback to default paths based on permission.
    if (path.nullSafe.isNotEmpty) {
      return path.nullSafe;
    } else if (shouldAskManageExternalPermission) {
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
      // Check if the platform is Android then try to get Thumbnail from Native Written Method.
      if (Platform.isAndroid) {
        return _videoToThumbnailIsolate(
          videoPath: path,
          method: _methodId,
          channel: _channelId,
          token: RootIsolateToken.instance,
        );
      }

      // For other platforms, use the VideoThumbnail plugin to get the thumbnail.
      // Specify the width of the thumbnail, let the height auto-scaled to keep the
      // source aspect ratio.
      return VideoThumbnail.thumbnailData(
        video: path,
        quality: 25,
        maxWidth: 128,
        imageFormat: ImageFormat.JPEG,
      );
    } catch (e) {
      // Log any errors that occur during the process.
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
  /// The function returns a Future<String?>, where the String is the Android path or null if there's an error.
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
