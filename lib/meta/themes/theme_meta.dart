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
        bodyColor: AppColors.kBlack.withValues(alpha: 0.9),
        displayColor: AppColors.kBlack.withValues(alpha: 0.95),
      ),
      primaryTextTheme: GoogleFonts.mulishTextTheme().apply(
        decorationColor: AppColors.kWhite,
        bodyColor: AppColors.kBlack.withValues(alpha: 0.9),
        displayColor: AppColors.kBlack.withValues(alpha: 0.95),
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
        primary: Color(0xFF0B6B3A),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFA0F5BC),
        onPrimaryContainer: Color(0xFF00210E),
        secondary: Color(0xFF4D6356),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFCFE9D7),
        onSecondaryContainer: Color(0xFF0A1F15),
        tertiary: Color(0xFF3D6373),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFC1E8FB),
        onTertiaryContainer: Color(0xFF001F29),
        error: Color(0xFFBA1A1A),
        errorContainer: Color(0xFFFFDAD6),
        onError: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFF410002),
        surface: Color(0xFFF6FBF4),
        onSurface: Color(0xFF171D19),
        surfaceContainerHighest: Color(0xFFDAE5DD),
        onSurfaceVariant: Color(0xFF404943),
        outline: Color(0xFF707972),
        onInverseSurface: Color(0xFFECF2EB),
        inverseSurface: Color(0xFF2C322D),
        inversePrimary: Color(0xFF84D8A2),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF0B6B3A),
        outlineVariant: Color(0xFFBFC9C1),
        scrim: Color(0xFF000000),
      ),
    );
  }

  /// Provide `Theme` for `DarkMode`
  ThemeData darkMode() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      textTheme: GoogleFonts.mulishTextTheme().apply(
        decorationColor: AppColors.kWhite,
        bodyColor: AppColors.kWhite.withValues(alpha: 0.9),
        displayColor: AppColors.kWhite.withValues(alpha: 0.95),
      ),
      primaryTextTheme: GoogleFonts.mulishTextTheme().apply(
        decorationColor: AppColors.kWhite,
        bodyColor: AppColors.kWhite.withValues(alpha: 0.9),
        displayColor: AppColors.kWhite.withValues(alpha: 0.95),
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
        primary: Color(0xFF84D8A2),
        onPrimary: Color(0xFF00391C),
        primaryContainer: Color(0xFF005229),
        onPrimaryContainer: Color(0xFFA0F5BC),
        secondary: Color(0xFFB4CDBC),
        onSecondary: Color(0xFF1F3529),
        secondaryContainer: Color(0xFF364B3F),
        onSecondaryContainer: Color(0xFFCFE9D7),
        tertiary: Color(0xFFA5CCDE),
        onTertiary: Color(0xFF073543),
        tertiaryContainer: Color(0xFF234C5A),
        onTertiaryContainer: Color(0xFFC1E8FB),
        error: Color(0xFFFFB4AB),
        errorContainer: Color(0xFF93000A),
        onError: Color(0xFF690005),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: Color(0xFF0F1511),
        onSurface: Color(0xFFDEE4DD),
        surfaceContainerHighest: Color(0xFF303630),
        onSurfaceVariant: Color(0xFFBFC9C1),
        outline: Color(0xFF89938C),
        onInverseSurface: Color(0xFF0F1511),
        inverseSurface: Color(0xFFDEE4DD),
        inversePrimary: Color(0xFF0B6B3A),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF84D8A2),
        outlineVariant: Color(0xFF404943),
        scrim: Color(0xFF000000),
      ),
    );
  }
}
