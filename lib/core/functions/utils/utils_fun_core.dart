import 'dart:io';

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
  void getDeviceInfo() async {
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

  /// The `shouldAskManageExternalPermission` function will return `true` if the Android version is 10 (SDK version 29) or higher.
  /// The function checks whether `_androidInfo` is not null (indicating that the Android device information is available)
  /// and whether the SDK version is greater than or equal to 29.
  /// If both conditions are met, it returns `true`; otherwise, it returns `false`.
  bool get shouldAskManageExternalPermission {
    // Check If android device information is not available then get Device info.
    if (_androidInfo == null) {
      getDeviceInfo();
    }
    return ((_androidInfo != null) && (_androidInfo!.version.sdkInt >= 29));
  }

  /// Create an Instance of `WaPathGeneratorUtil`
  late final WaPathGeneratorUtil _waPathGeneratorUtil = WaPathGeneratorUtil();

  /// Provide `WhatsApp Path` to `Status`
  Future<String> get whatsAppPath async {
    final String? path = await _waPathGeneratorUtil
        .whatsAppPath(shouldAskManageExternalPermission);
    if (path.nullSafe.isNotEmpty) {
      return path.nullSafe;
    } else if (shouldAskManageExternalPermission) {
      return "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
    } else {
      return "/storage/emulated/0/WhatsApp/Media/.Statuses";
    }
  }

  /// Provide `WhatsApp Business Path` to `Status`
  Future<String> get whatsAppBusinessPath async {
    final String? path = await _waPathGeneratorUtil
        .businessWaPath(shouldAskManageExternalPermission);
    if (path.nullSafe.isNotEmpty) {
      return path.nullSafe;
    } else if (shouldAskManageExternalPermission) {
      return "/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";
    } else {
      return "/storage/emulated/0/WhatsApp Business/Media/.Statuses";
    }
  }

  /// Get `Thumbnail` from `Video`.
  Future<String> getThumbnail(String path) {
    return VideoThumbnail.thumbnailFile(video: path).then(
      (String? value) => value.nullSafe,
    );
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

  Future<String?> _getAndroidPath() async {
    try {
      // Get External Storage Directory Path
      Directory? directory = await getExternalStorageDirectory();
      directory?.path.print("_getAndroidPath - RawPath");
      // Make sure directory is not null
      if (directory != null) {
        // Convert directory path into List
        final List<String> paths = directory.path.split("/");
        final String newPath =
            paths.sublist(1, paths.indexOf("Android")).join("/");
        directory = Directory(newPath);
        return directory.path;
      }
    } catch (e) {
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
