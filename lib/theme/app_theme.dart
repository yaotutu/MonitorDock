import 'package:flutter/material.dart';

/// Material Design 3 官方主题配置
class AppTheme {
  AppTheme._();

  /// Material 3 调色板 - 基于 Material Theme Builder 生成
  // Primary
  static const Color primary = Color(0xFF6750A4); // M3 默认主色
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005E);

  // Secondary
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondaryContainer = Color(0xFF1E192B);

  // Tertiary
  static const Color tertiary = Color(0xFF7D5260);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  // Surface
  static const Color surface = Color(0xFFFFFBFE);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Background
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);

  // Error
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // Outline
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  /// 状态颜色
  static const Color success = Color(0xFF146C2E);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info = Color(0xFF2196F3);

  /// 阴影配置 - Material Design 3 风格
  static List<BoxShadow> elevation1 = [
    BoxShadow(
      color: onBackground.withOpacity(0.05),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static List<BoxShadow> elevation2 = [
    BoxShadow(
      color: onBackground.withOpacity(0.08),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  /// 文字样式 - Material Design 3 Typography
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: onBackground,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: onBackground,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
    color: onBackground,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: onBackground,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: onBackground,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: onBackground,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: onBackground,
  );

  /// 卡片装饰
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(28), // M3 推荐的大圆角
    border: Border.all(
      color: outlineVariant,
      width: 1,
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
        return error;
      default:
        return onSurfaceVariant;
    }
  }
}
