import 'package:flutter/material.dart';
import '../../core/block/base_block.dart';
import '../../core/block/block_overflow.dart';
import 'clock_controller.dart';
import 'clock_display.dart';

class ClockBlock extends StatefulWidget {
  const ClockBlock({super.key});

  @override
  State<ClockBlock> createState() => _ClockBlockState();
}

class _ClockBlockState extends State<ClockBlock> {
  late final ClockController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ClockController();
    _controller.startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBlock(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return ClockDisplay(time: _controller.currentTime);
        },
      ),
    );
  }
}
