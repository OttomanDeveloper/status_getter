import 'package:flutter/material.dart';

/// Provide Extra Extensions On `BuildContext`
extension BuildContextExtendedExtensions<T> on BuildContext {
  /// `mediaQuery`
  ///
  /// Provide `Device Details` Using `MediaQuery` API
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// `sizeApi`
  ///
  /// Provide `Device Size` Using `MediaQuery.sizeOf` API
  Size get sizeApi => MediaQuery.sizeOf(this);

  /// `width`
  ///
  /// Provide device Width Using `MediaQuery` API
  double get width => sizeApi.width;

  /// `width`
  ///
  /// Provide `device Height` Using `MediaQuery` API
  double get height => sizeApi.height;

  /// `theme`
  ///
  /// Provide `Active theme data`
  ThemeData get theme => Theme.of(this);

  /// `primaryText`
  ///
  /// Provide `Primary Text Theme` Using `Theme` API
  TextTheme get primaryText => theme.primaryTextTheme;

  /// `textTheme`
  ///
  /// Provide `Text Theme` Using `Theme` API. It's not Primary
  TextTheme get textTheme => theme.textTheme;

  /// `bgColor`
  ///
  /// Provide `scaffold Background Color` Using `Theme` API
  Color get bgColor => theme.scaffoldBackgroundColor;

  /// `schemeBrightness`
  ///
  /// Provide `Brightness` Using `Theme` API
  Brightness get schemeBrightness {
    if (theme.colorScheme.brightness == Brightness.dark) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  /// `appBar`
  ///
  /// Provide `AppBarTheme` Using `Theme` API
  AppBarTheme get appBar => theme.appBarTheme;

  /// `popNavigator`
  ///
  /// Pop the `top-most` route off the `navigator` that most tightly encloses the given `context`.
  ///
  /// It's equal to `Navigator.pop(context)`
  void popNavigator([T? result]) => Navigator.pop(this, result);
}
