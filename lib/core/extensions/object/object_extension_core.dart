import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Provide Extra Extensions On `Object?`
extension ObjectExtendedExtensions on Object? {
  /// `print`
  ///
  /// Print `Error` Details in `Debug Console` [Only Debug Mode]
  ///
  /// This extension method is designed to provide enhanced logging functionality.
  ///
  /// In debug mode, it uses the `log` function from `dart:developer` to print the
  /// message along with the string representation of the object to the console.
  ///
  /// In release mode, it uses `debugPrint` to print the same information to the console.
  ///
  /// Usage:
  ///
  /// ```dart
  /// someObject.print("Custom Message");
  /// ```
  ///
  /// This will print the custom message along with the string representation of
  /// `someObject` to the console, but only in debug mode.
  void print([String? message]) {
    // Check if the app is running in debug mode
    if (kDebugMode) {
      // In debug mode, use log for more detailed information
      return log("${message ?? "Logger:) "} => ${toString()}");
    } else {
      // In release mode, use debugPrint for concise output
      return debugPrint("${message ?? "Logger:) "} => ${toString()}");
    }
  }
}
