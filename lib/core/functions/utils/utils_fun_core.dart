import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
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

  /// Check should we ask for External Storage permission or not
  bool get shouldAskManageExternalPermission {
    // Check If android device information is not available then get Device info.
    if (_androidInfo == null) {
      getDeviceInfo();
    }
    return ((_androidInfo != null) && (_androidInfo!.version.sdkInt > 30));
  }

  /// Provide `WhatsApp Path` to `Status`
  String get whatsAppPath {
    if (shouldAskManageExternalPermission) {
      return "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
    } else {
      return "/storage/emulated/0/WhatsApp/Media/.Statuses";
    }
  }

  /// Provide `WhatsApp Business Path` to `Status`
  String get whatsAppBusinessPath {
    if (shouldAskManageExternalPermission) {
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
