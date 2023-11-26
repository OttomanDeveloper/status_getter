import 'package:flutter/material.dart';

@immutable
abstract class AppColors {
  const AppColors._();

  /// Common Colors
  static const Color kGrey = Colors.grey;
  static const Color kBlack = Colors.black;
  static const Color kWhite = Colors.white;
  static const Color noColor = Colors.transparent;

  /// In a Flutter color detector application,
  /// if you need to determine whether to apply white or black color based on the background color,
  /// you can use the concept of color contrast to make the text or UI element more legible and accessible.
  static Color getTextColorBasedOnBackground(Color backgroundColor) {
    // Calculate contrast ratios
    final contrastWithBlack = calculateContrastRatio(backgroundColor, kBlack);
    final contrastWithWhite = calculateContrastRatio(backgroundColor, kWhite);
    // Choose the text color based on contrast ratio
    if (contrastWithBlack > contrastWithWhite) {
      return kBlack;
    } else {
      return kWhite;
    }
  }

  /// Calculate the relative luminance of a color
  static double calculateRelativeLuminance(Color color) {
    return (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) / 255;
  }

  /// Calculate the contrast ratio between two colors
  static double calculateContrastRatio(Color color1, Color color2) {
    final double luminance1 = (calculateRelativeLuminance(color1) + 0.05);
    final double luminance2 = (calculateRelativeLuminance(color2) + 0.05);
    if (luminance1 > luminance2) {
      return luminance1 / luminance2;
    } else {
      return luminance2 / luminance1;
    }
  }
}
