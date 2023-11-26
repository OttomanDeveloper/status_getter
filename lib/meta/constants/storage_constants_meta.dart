import 'package:flutter/material.dart';

@immutable
abstract class StorageConstants {
  const StorageConstants._();

  /// Hold `Theme Mode` Database `Key`
  static const String themeMode = "theme_mode_key";

  /// Hold `Dashboard` Navigation `Index` Database `Key`
  static const String dashNavIndex = "dashboard_nav_key";

  /// Hold `Ads` Database `Key`
  static const String ads = "ads_key";
}
