import 'package:flutter/material.dart';
import 'widgets/scrollable_blocks_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScrollableBlocksView(),
    );
  }
}
