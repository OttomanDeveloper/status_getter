import 'package:flutter/material.dart';

@immutable
abstract class AppSettings {
  const AppSettings._();

  /// Contains `Application Name`
  static const String appName = "Status Getter";

  /// This `String` contains `nothing` but `empty`
  static const String empty = "";

  /// This `String` contains `Space`
  static const String space = " ";

  /// This `String` contains a `comma`
  static const String comma = ",";

  /// This `String` contains a `Default Avatar URL`
  static const String defaultAvatarUrl = 'https://via.placeholder.com/150';

  /// `Banner Ad` in `ListView` After `Number of Item`
  static const int listBannerAdAfter = 5;

  /// This `String` contains `information` about `share message`
  static const String shareMessage =
      "Save WhatsApp and Business WhatsApp statuses in video or image format, or directly share them with your friends. Additionally, save any video from social media by simply pasting the video link; you will then be presented with multiple options to save the video to your phone storage.";
}
