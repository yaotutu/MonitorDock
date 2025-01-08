import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 应用程序初始化工具类
class AppInit {
  /// 初始化应用程序设置
  static Future<void> initialize() async {
    try {
      // 确保Flutter绑定初始化
      WidgetsFlutterBinding.ensureInitialized();

      // 设置系统UI模式
      await _setupSystemUI();

      // 设置屏幕方向
      await _setupOrientation();

      // 设置系统导航栏颜色
      _setupSystemNavigationBar();
    } catch (e) {
      debugPrint('应用初始化失败: $e');
      rethrow;
    }
  }

  /// 设置系统UI模式
  static Future<void> _setupSystemUI() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  /// 设置屏幕方向
  static Future<void> _setupOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// 设置系统导航栏
  static void _setupSystemNavigationBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
