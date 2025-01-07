import 'package:flutter/material.dart';
import '../base/base_block.dart';
import '../base/block_overflow.dart';
import 'clock_controller.dart';
import 'clock_display.dart';
import 'clock_detail_view.dart';

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
    _controller = ClockController()..startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBlock(
      title: '时间',
      overflowMode: BlockOverflowMode.clip,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return ClockDisplay(time: _controller.currentTime);
        },
      ),
      secondaryView: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return ClockDetailView(time: _controller.currentTime);
        },
      ),
    );
  }
}