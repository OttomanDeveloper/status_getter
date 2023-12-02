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
  /// It will calculate how much height this `String` characters will take.
  ///
  /// Parameters:
  ///   - `maxLines`: An optional parameter to set the maximum number of lines for the text. Defaults to `1`.
  ///   - `style`: An optional parameter to specify the text style using the `TextStyle` class. Defaults to an empty style.
  ///   - `maxWidth`: An optional parameter to set the maximum width available for the text. Defaults to `double.infinity`, meaning there's no constraint on width.
  ///
  /// Returns:
  ///   - A `TextPainter` object that contains information about the size and layout of the text.
  ///
  /// Example:
  /// ```dart
  /// final String text = "Hello, Flutter!";
  /// final TextStyle myTextStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  ///
  /// final TextPainter painter = text.findSize(style: myTextStyle, maxWidth: 200.0);
  ///
  /// // Access size information
  /// final double textWidth = painter.width;
  /// final double textHeight = painter.height;
  /// ```

  TextPainter findSize({
    int? maxLines,
    TextStyle? style,
    double? maxWidth,
  }) {
    // Get TextSpan with text and style
    final TextSpan textSpan = TextSpan(
      text: this,
      style: style ?? const TextStyle(),
    );

    // Get Text Details in a TextPainter Variable
    final TextPainter painter = TextPainter(
      text: textSpan,
      maxLines: maxLines ?? 1,
      textDirection: TextDirection.ltr,
    );

    // Assign Layout details
    painter.layout(maxWidth: maxWidth ?? double.infinity);

    // Return size
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
  ///
  /// This function takes an optional [Uri] parameter representing the path or URL
  /// that you want to open. It returns a [Future<bool>] indicating whether the
  /// operation was successful.
  ///
  /// Example Usage:
  /// ```dart
  /// Uri uri = Uri.parse("https://example.com");
  /// bool isOpened = await openURL(path: uri);
  /// ```
  ///
  /// The function first attempts to parse the input [path] into a [Uri]. If the
  /// parsing is unsuccessful, it defaults to `nullSafe`, which could be the case
  /// when the input [path] is already a [Uri] or if it is `null`.
  ///
  /// It then validates the parsed [url] by checking if it is not `null` and if
  /// it can be launched using the [canLaunchUrl] function.
  ///
  /// If the [url] is valid and can be launched, it invokes the [launchUrl] function
  /// with the [url] and a specified [mode] (in this case, `LaunchMode.externalApplication`).
  ///
  /// If any errors occur during this process, they are caught and printed to the console.
  ///
  /// Returns `true` if the [url] was successfully opened, and `false` otherwise.
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
