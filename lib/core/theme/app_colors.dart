import 'package:flutter/material.dart';

/// App color theme configuration
class AppColors {
  /// Primary blue color (iOS style)
  static const primary = Color(0xFF007AFF);

  /// Secondary purple color (iOS style)
  static const secondary = Color(0xFF5856D6);

  /// Error red color (iOS style)
  static const error = Color(0xFFFF3B30);

  /// Label gray color (iOS style)
  static const label = Color(0xFF8E8E93);

  /// Surface color for dark theme
  static const surfaceDark = Colors.black;

  /// Surface color for light theme
  static const surfaceLight = Colors.white;

  /// Background color for dark theme container
  static const containerDark = Color(0x30FFFFFF);

  /// Background color for light theme container
  static const containerLight = Color(0xF5FFFFFF);

  /// Border color for dark theme
  static const borderDark = Color(0x1FFFFFFF);

  /// Border color for light theme
  static const borderLight = Color(0x1F000000);

  /// Get surface color based on brightness
  static Color getSurfaceColor(bool isDark) {
    return isDark ? surfaceDark : surfaceLight;
  }

  /// Get container background color based on brightness
  static Color getContainerColor(bool isDark) {
    return isDark ? containerDark : containerLight;
  }

  /// Get border color based on brightness
  static Color getBorderColor(bool isDark) {
    return isDark ? borderDark : borderLight;
  }
}
