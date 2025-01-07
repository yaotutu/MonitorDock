import 'package:flutter/material.dart';
import 'app.dart';
import 'utils/app_init.dart';

/// 应用程序入口
void main() async {
  // 初始化应用程序设置（横屏、全屏等）
  await AppInit.initialize();
  // 运行应用程序
  runApp(const App());
}
