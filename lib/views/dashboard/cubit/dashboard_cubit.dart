import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:statusgetter/meta/constants/storage_constants_meta.dart';

class DashboardCubit extends HydratedCubit<int> {
  DashboardCubit() : super(_initialIndex);

  /// Emit new state if the bloc is not closed.
  void emitState(int state) {
    if (!isClosed) {
      return emit(state);
    }
  }

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

  /// Update the value of `bottomNavIndex` and optionally move to the corresponding page.
  ///
  /// This method emits the provided event to notify listeners about the change in the bottom navigation index.
  /// If [movePage] is `true`, it also moves the `PageController` to the corresponding page.
  ///
  /// Parameters:
  /// - [event]: The new index for the bottom navigation.
  /// - [movePage]: A boolean indicating whether to move the `PageController` to the corresponding page.
  void updateBottomNavIndex(int event, {required bool movePage}) {
    // Verify the user is navigating to a new page, not the current one
    if (event != state) {
      // Make sure the stream is active
      emitState(event);
      // Now check if it has to move the page, then move it
      if (movePage) {
        pageController.jumpToPage(event);
      }
    }
    return;
  }

  /// Hold `GlobalKey` of `ScaffoldState` for `Drawer` to Handle Drawer `Opening` and `Closing`.
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  /// Hold `HydratedCubit` Data Key.
  final String _dataKey = StorageConstants.dashNavIndex;

  @override
  int? fromJson(Map<String, dynamic> json) {
    return (json[_dataKey] as int?) ?? _initialIndex;
  }

  @override
  Map<String, dynamic>? toJson(int state) {
    return {_dataKey: state};
  }
}
