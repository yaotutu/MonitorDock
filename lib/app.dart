import 'package:flutter/material.dart';
import 'features/home/home_view.dart';

/// 应用程序根组件
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const HomeView(),
    );
  }
}
