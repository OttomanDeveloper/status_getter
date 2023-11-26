import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Provide Extra Extensions On `Object?`
extension ObjectExtendedExtensions on Object? {
  /// `print`
  ///
  /// Print `Error` Details in `Debug Console` [Only Debug Mode]
  void print([String? message]) {
    if (kDebugMode) {
      return log("${message ?? "Logger:) "} => ${toString()}");
    } else {
      return debugPrint("${message ?? "Logger:) "} => ${toString()}");
    }
  }
}
