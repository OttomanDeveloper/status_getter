import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';

@immutable
class AppThemes {
  /// Create an Instance
  static AppThemes? _instance;

  /// Privatised the constructor
  AppThemes._internal() {
    "AppThemes constructor called".print();
  }

  /// Provide a instance whenever it's needed
  factory AppThemes() {
    // Provide a instance if not initialized yet
    _instance ??= AppThemes._internal();
    return _instance!;
  }

  /// For `Scaffold Background Color`
  SystemUiOverlayStyle normalGB(BuildContext context) {
    return SystemUiOverlayStyle(
      statusBarColor: context.bgColor,
      systemNavigationBarColor: context.bgColor,
      statusBarBrightness: context.schemeBrightness,
      statusBarIconBrightness: context.schemeBrightness,
      systemNavigationBarIconBrightness: context.schemeBrightness,
    );
  }

  /// For `Primary Color in Status bar and Scaffold Background Color`
  SystemUiOverlayStyle primaryWithBG(BuildContext context) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: context.bgColor,
      statusBarBrightness: context.schemeBrightness,
      statusBarColor: context.theme.colorScheme.primary,
      statusBarIconBrightness: context.schemeBrightness,
      systemNavigationBarIconBrightness: context.schemeBrightness,
    );
  }

  /// Provide `Theme` for `LightMode`
  ThemeData lightMode() {
    return ThemeData.light(useMaterial3: true).copyWith(
      textTheme: GoogleFonts.mulishTextTheme().apply(
        decorationColor: AppColors.kBlack,
        bodyColor: AppColors.kBlack.withOpacity(0.9),
        displayColor: AppColors.kBlack.withOpacity(0.95),
      ),
      primaryTextTheme: GoogleFonts.mulishTextTheme().apply(
        decorationColor: AppColors.kWhite,
        bodyColor: AppColors.kBlack.withOpacity(0.9),
        displayColor: AppColors.kBlack.withOpacity(0.95),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        actionsIconTheme: const IconThemeData(color: AppColors.kWhite),
        titleTextStyle: GoogleFonts.mulish(
          fontSize: 24.0,
          color: AppColors.kWhite,
        ),
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF006D40),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF95F7B9),
        onPrimaryContainer: Color(0xFF002110),
        secondary: Color(0xFF4F6354),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFD1E8D5),
        onSecondaryContainer: Color(0xFF0C1F14),
        tertiary: Color(0xFF3B6470),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFBFE9F8),
        onTertiaryContainer: Color(0xFF001F27),
        error: Color(0xFFBA1A1A),
        errorContainer: Color(0xFFFFDAD6),
        onError: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFF410002),
        surface: Color(0xFFFBFDF8),
        onSurface: Color(0xFF191C1A),
        surfaceContainerHighest: Color(0xFFDCE5DB),
        onSurfaceVariant: Color(0xFF414942),
        outline: Color(0xFF717971),
        onInverseSurface: Color(0xFFF0F1EC),
        inverseSurface: Color(0xFF2E312E),
        inversePrimary: Color(0xFF79DA9F),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF006D40),
        outlineVariant: Color(0xFFC0C9C0),
        scrim: Color(0xFF000000),
      ),
    );
  }

  /// Provide `Theme` for `DarkMode`
  ThemeData darkMode() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      textTheme: GoogleFonts.mulishTextTheme().apply(
        decorationColor: AppColors.kWhite,
        bodyColor: AppColors.kWhite.withOpacity(0.9),
        displayColor: AppColors.kWhite.withOpacity(0.95),
      ),
      primaryTextTheme: GoogleFonts.mulishTextTheme().apply(
        decorationColor: AppColors.kWhite,
        bodyColor: AppColors.kWhite.withOpacity(0.9),
        displayColor: AppColors.kWhite.withOpacity(0.95),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        actionsIconTheme: const IconThemeData(color: AppColors.kWhite),
        titleTextStyle: GoogleFonts.mulish(
          fontSize: 24.0,
          color: AppColors.kWhite,
        ),
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF79DA9F),
        onPrimary: Color(0xFF00391F),
        primaryContainer: Color(0xFF00522F),
        onPrimaryContainer: Color(0xFF95F7B9),
        secondary: Color(0xFFB5CCBA),
        onSecondary: Color(0xFF213528),
        secondaryContainer: Color(0xFF374B3D),
        onSecondaryContainer: Color(0xFFD1E8D5),
        tertiary: Color(0xFFA3CDDB),
        onTertiary: Color(0xFF033641),
        tertiaryContainer: Color(0xFF214C58),
        onTertiaryContainer: Color(0xFFBFE9F8),
        error: Color(0xFFFFB4AB),
        errorContainer: Color(0xFF93000A),
        onError: Color(0xFF690005),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: Color(0xFF191C1A),
        onSurface: Color(0xFFE1E3DE),
        onSurfaceVariant: Color(0xFFC0C9C0),
        outline: Color(0xFF8A938B),
        onInverseSurface: Color(0xFF191C1A),
        inverseSurface: Color(0xFFE1E3DE),
        inversePrimary: Color(0xFF006D40),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF79DA9F), 
        outlineVariant: Color(0xFF414942),
        scrim: Color(0xFF000000),
      ),
    );
  }
}
