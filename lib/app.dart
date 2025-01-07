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
      theme: ThemeData(
        useMaterial3: true, // 启用 Material 3
        colorScheme: ColorScheme.light(
          primary: AppTheme.primary,
          onPrimary: AppTheme.onPrimary,
          secondary: AppTheme.secondary,
          onSecondary: AppTheme.onSecondary,
          error: AppTheme.error,
          background: AppTheme.background,
          surface: AppTheme.surface,
        ),
      ),
      home: const ScrollableBlocksView(),
    );
  }
}
