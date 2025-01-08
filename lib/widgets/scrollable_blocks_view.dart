import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'block/clock/clock_block.dart';
import 'block/server_status/server_status_block.dart';

class ScrollableBlocksView extends StatelessWidget {
  const ScrollableBlocksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightColorScheme.background,
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
                    ClockBlock(),
                    SizedBox(width: 16),
                    ServerStatusBlock(),
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
