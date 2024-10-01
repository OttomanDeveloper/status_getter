import 'package:flutter/material.dart';

@immutable
abstract class WaConstants {
  const WaConstants._();

  /// Hold `WhatsApp` Package Name
  static const String wa = "com.whatsapp";

  /// Hold `WhatsApp Business` Package Name
  static const String w4b = "com.whatsapp.w4b";

  /// This function returns the file path to the WhatsApp statuses directory.
  /// The path returned depends on whether the device is running Android 11 or higher.
  String whatsAppPath(bool isAndroid11) {
    // Using a switch expression to determine the correct file path based on the Android version.
    return switch (isAndroid11) {
      // For Android versions lower than 11, return the standard path to WhatsApp statuses.
      false => "/storage/emulated/0/WhatsApp/Media/.Statuses",
      // For Android 11 and higher, return the new scoped storage path for WhatsApp statuses.
      true => "/storage/emulated/0/Android/media/$wa/WhatsApp/Media/.Statuses",
    };
  }

  /// This function returns the file path to the WhatsApp Business statuses directory.
  /// The path returned depends on whether the device is running Android 11 or higher.
  String whatsAppBusinessPath(bool isAndroid11) {
    // Using a switch expression to determine the correct file path based on the Android version.
    return switch (isAndroid11) {
      // For Android versions lower than 11, return the standard path to WhatsApp Business statuses.
      false => "/storage/emulated/0/WhatsApp Business/Media/.Statuses",
      // For Android 11 and higher, return the new scoped storage path for WhatsApp Business statuses.
      true =>
        "/storage/emulated/0/Android/media/$w4b/WhatsApp Business/Media/.Statuses",
    };
  }
}
