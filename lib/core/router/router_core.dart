import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/router/router_name.dart';
import 'package:statusgetter/core/router/router_page_animation.dart';
import 'package:statusgetter/views/dashboard/dashboard_view.dart';
import 'package:statusgetter/views/splash/splash_view.dart';

@immutable
class RouterNavigator {
  /// Instance for this class
  static RouterNavigator? _instance;

  /// Privatised the constructor
  RouterNavigator._internal() {
    "RouterNavigator constructor called".print();
  }

  /// Provide a instance whenever it's needed
  factory RouterNavigator() {
    // Provide a instance if not initialized yet
    _instance ??= RouterNavigator._internal();
    return _instance!;
  }

  final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.splash,
    routes: <GoRoute>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, GoRouterState state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        pageBuilder: (_, GoRouterState state) {
          return FadePageAnimation(
            state: state,
            child: const DashboardView(),
          );
        },
      ),
    ],
  );
}
