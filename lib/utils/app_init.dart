import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppInit {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 设置全屏和系统UI
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );

    // 设置横屏方向
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
