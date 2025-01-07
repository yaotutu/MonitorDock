import 'package:flutter/material.dart';
import 'block/clock/clock_block.dart';
import 'block/server_status/server_status_block.dart';

class ScrollableBlocksView extends StatelessWidget {
  const ScrollableBlocksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ClockBlock(),
              SizedBox(width: 16),
              ServerStatusBlock(),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
