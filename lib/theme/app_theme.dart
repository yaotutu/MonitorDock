import 'package:flutter/material.dart';

/// Material Design 3 主题配置
class AppTheme {
  AppTheme._();

  // Material 3 调色板
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6750A4),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005E),
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1E192B),
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceTint: Color(0xFF6750A4),
    surfaceContainerHighest: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFFD0BCFF),
    // 新的 Material 3 颜色
    scrim: Color(0xFF000000),
  );

  /// 功能色
  static const Color success = Color(0xFF146C2E);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info = Color(0xFF2196F3);

  /// 阴影配置
  static List<BoxShadow> elevation1 = [
    BoxShadow(
      color: lightColorScheme.shadow.withAlpha(13),
      offset: const Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  /// 文字样式
  static TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: lightColorScheme.onSurface,
  );

  static TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: lightColorScheme.onSurface,
  );

  static TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
    color: lightColorScheme.onSurface,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: lightColorScheme.onSurface,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: lightColorScheme.onSurface,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: lightColorScheme.onSurface,
  );

  static TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: lightColorScheme.onSurface,
  );

  /// 卡片装饰
  static BoxDecoration cardDecoration = BoxDecoration(
    color: lightColorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: lightColorScheme.outline.withAlpha(128),
      width: 0.5,
    ),
    boxShadow: elevation1,
  );

  /// 获取状态颜色
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'running':
        return success;
      case 'warning':
        return warning;
      case 'error':
        return lightColorScheme.error;
      default:
        return lightColorScheme.onSurface;
    }
  }
}
