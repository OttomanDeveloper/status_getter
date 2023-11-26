import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:statusgetter/meta/constants/storage_constants_meta.dart';

class DashboardCubit extends HydratedCubit<int> {
  DashboardCubit() : super(_initialIndex);

  /// Hold Default `Initial Index` Value
  static const int _initialIndex = 0;

  /// Create an Instance of `PageController`
  late final PageController pageController = PageController(
    initialPage: state,
  );

  /// `Dispose` the `resources`
  void dispose() {
    pageController.dispose();
  }

  /// update the value of `bottomNavIndex`
  void updateBottomNavIndex(int event, {required bool movePage}) {
    // Verify user is navigating to a new page. not a new one
    if (event != state) {
      // Make sure stream is active
      emit(event);
      // Now check if it have to move the page then move it
      if (movePage) {
        pageController.jumpToPage(event);
      }
    }
    return;
  }

  /// Hold `GlobalKey` of `ScaffoldState` for `Drawer` to Handle Drawer `Opening` and `Closing`.
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  int? fromJson(Map<String, dynamic> json) {
    return (json[StorageConstants.dashNavIndex] as int?) ?? _initialIndex;
  }

  @override
  Map<String, dynamic>? toJson(int state) {
    return {StorageConstants.dashNavIndex: state};
  }
}
