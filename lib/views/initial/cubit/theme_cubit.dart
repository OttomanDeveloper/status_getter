import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:statusgetter/meta/constants/storage_constants_meta.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Change `App` Theme `Mode`
  void toggleTheme(ThemeMode mode) => emit(mode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[(json[StorageConstants.themeMode] as int?) ?? 0];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {StorageConstants.themeMode: state.index};
  }
}
