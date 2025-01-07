import 'package:flutter/material.dart';
import 'block/clock/clock_block.dart';
import 'block/server_status/server_status_block.dart';

class ScrollableBlocksView extends StatelessWidget {
  const ScrollableBlocksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[200],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ClockBlock(),
              SizedBox(width: 10),
              ServerStatusBlock(),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
