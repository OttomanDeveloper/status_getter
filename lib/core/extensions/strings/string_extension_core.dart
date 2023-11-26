import 'package:flutter/cupertino.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/views/widgets/snack_bar/snack_bar_utils_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provide extra extension on String nullable type
extension StringExtendedExtensions on String? {
  /// `nullSafe`
  ///
  /// If `String` contains null then return a empty `String`
  /// otherwise return given `String`
  String get nullSafe => (this ?? AppSettings.empty);

  /// `isEmpty`
  ///
  /// If given `String` is empty then return `false` otherwise `true`
  bool get isEmpty => nullSafe.isEmpty;

  /// `isNotEmpty`
  ///
  /// If given `String` is not empty then return `true` otherwise `false`
  bool get isNotEmpty => nullSafe.isNotEmpty;

  /// `isProperURL`
  ///
  /// Check Provided `String` is Proper `Url` Type or Not
  bool get isProperURL {
    // Make sure provided string is not empty
    if (isNotEmpty) {
      try {
        // Apply is URL function
        return Uri.parse(nullSafe).isAbsolute;
      } catch (e) {
        /// Print Error in Debug Console
        "StringExtendedExtensions isProperURL Error: ${e.toString()}".print();
      }
    }
    // provided string is empty so we can't apply URL checker
    return false;
  }

  /// `findSize`
  ///
  /// Find TextSize based on Given `String` and `TextStyle`
  ///
  /// It will calculate how much height this `String` characters will take
  ///
  /// `return` data type will be in `TextPainter`
  TextPainter findSize({
    int? maxLines,
    TextStyle? style,
    double? maxWidth,
  }) {
    // Get TextSpan width text and style
    final TextSpan textSpan = TextSpan(
      text: this,
      style: style ?? const TextStyle(),
    );
    // Get Text Details in painter Variable
    final TextPainter painter = TextPainter(
      text: textSpan,
      maxLines: maxLines ?? 1,
      textDirection: TextDirection.ltr,
    );
    // Assign Layout details
    painter.layout(maxWidth: maxWidth ?? double.infinity);
    // return size
    return painter;
  }

  /// `isSame()` function
  ///
  /// will check if provided and attached values
  ///
  /// are same in `toLowerCase()` then return `true` otherwise `false`
  bool isSame(String? value) {
    return (nullSafe.toLowerCase() == value.nullSafe.toLowerCase());
  }

  /// `customContains()` function
  ///
  /// will check if attach data contains provided value.
  ///
  /// then return `true` otherwise `false`
  bool customContains(String? value) {
    // Check if value is null then don't do anything
    if (value.nullSafe.isEmpty) {
      return false;
    } else {
      return nullSafe.toLowerCase().contains(value.nullSafe.toLowerCase());
    }
  }

  /// This function will check `Space` in given `String`
  bool get hasSpace => nullSafe.contains(AppSettings.space);

  /// `showSnackbar`
  ///
  /// Show snackbar on given string
  Future<void> showSnackbar(
    BuildContext context, {
    Color? bgColor,
    IconData icon = CupertinoIcons.info,
  }) {
    return snackbar(
      context,
      icon: icon,
      msg: nullSafe,
      bgColor: bgColor,
    );
  }

  /// `openURL`
  ///
  /// Open `URI` in `browser` or `supported apps`
  Future<bool> openURL({Uri? path}) async {
    try {
      // Parse the `String` into `Uri`
      final Uri? url = (path ?? Uri.tryParse(nullSafe));
      // Validate the Url
      if ((url != null) && (await canLaunchUrl(url))) {
        return launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      e.toString().print("openURL Error");
    }
    // return false because url failed to open
    return false;
  }
}
