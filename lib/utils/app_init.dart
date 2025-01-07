import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 应用程序初始化工具类
class AppInit {
  /// 初始化应用程序设置
  static Future<void> initialize() async {
    // 确保Flutter绑定初始化
    WidgetsFlutterBinding.ensureInitialized();

    // 设置全屏模式，隐藏系统UI（状态栏和导航栏）
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
      overlays: [],
    );

    // 强制横屏显示
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, // 允许左横屏
      DeviceOrientation.landscapeRight, // 允许右横屏
    ]);
  }
}
