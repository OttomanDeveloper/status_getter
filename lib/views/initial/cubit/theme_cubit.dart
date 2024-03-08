import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:statusgetter/meta/constants/storage_constants_meta.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Emit new state if the bloc is not closed.
  void emitState(ThemeMode state) {
    if (!isClosed) {
      return emit(state);
    }
  }

  /// Change `App` Theme `Mode`
  void toggleTheme(ThemeMode mode) => emitState(mode);

  /// Hold `HydratedCubit` Data Key.
  final String _dataKey = StorageConstants.themeMode;

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[(json[_dataKey] as int?) ?? 0];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {_dataKey: state.index};
  }
}
