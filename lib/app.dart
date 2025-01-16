import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'features/home/home_view.dart';

/// 应用程序根组件
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: const HomeView(),
    );
  }
}
