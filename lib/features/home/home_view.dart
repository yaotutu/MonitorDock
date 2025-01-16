import 'package:flutter/material.dart';
import '../../dock_blocks/clock/clock_block.dart';
import '../../dock_blocks/clash/clash_block.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    // ClockBlock(),
                    // SizedBox(width: 16),
                    ClashBlock(),
                    SizedBox(width: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
