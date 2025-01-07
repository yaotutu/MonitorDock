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
        useMaterial3: true,
        colorScheme: AppTheme.lightColorScheme,
        dividerTheme: DividerThemeData(
          color: AppTheme.lightColorScheme.outline.withAlpha(128),
          thickness: 0.5,
        ),
      ),
      home: const ScrollableBlocksView(),
    );
  }
}
