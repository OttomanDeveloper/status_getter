import 'package:flutter/material.dart';

@immutable
abstract class AppRoutes {
  const AppRoutes._();

  /// Route path for `SplashView`
  static const String splash = "/";

  /// Route path for `DashboardView`
  static const String dashboard = "/dashboard";
}
