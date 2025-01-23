import 'package:flutter/material.dart';

import 'features/demo/block_demo_view.dart';

/// 应用程序根组件
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '监控面板演示',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BlockDemoView(),
    );
  }
}
