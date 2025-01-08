import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/scrollable_blocks_view.dart';

/// 应用程序根组件
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // 跟随系统主题
      home: const ScrollableBlocksView(),
    );
  }
}
