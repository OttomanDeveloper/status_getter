import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Provide `Slide` `Transition` Route
@immutable
class SlidePageAnimation extends CustomTransitionPage<void> {
  SlidePageAnimation({
    required super.child,
    required GoRouterState state,
  }) : super(
          name: state.name,
          key: state.pageKey,
          arguments: state.extra,
          transitionsBuilder: (_, Animation<double> a, __, Widget child) {
            return SlideTransition(
              position: a.drive(Tween<Offset>(
                begin: const Offset(0.25, 0.25),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeIn))),
              child: child,
            );
          },
        );
}

/// Provide `Scale` `Transition` Route
@immutable
class ScalePageAnimation extends CustomTransitionPage<void> {
  ScalePageAnimation({
    required super.child,
    required GoRouterState state,
  }) : super(
          name: state.name,
          key: state.pageKey,
          arguments: state.extra,
          transitionsBuilder: (_, Animation<double> a, __, Widget child) {
            return ScaleTransition(scale: a, child: child);
          },
        );
}

/// Provide `Fade` `Transition` Route
@immutable
class FadePageAnimation extends CustomTransitionPage<void> {
  FadePageAnimation({
    required super.child,
    required GoRouterState state,
  }) : super(
          name: state.name,
          key: state.pageKey,
          arguments: state.extra,
          transitionsBuilder: (_, Animation<double> a, __, Widget child) {
            return FadeTransition(
              opacity: a.drive(CurveTween(curve: Curves.easeIn)),
              child: child,
            );
          },
        );
}
