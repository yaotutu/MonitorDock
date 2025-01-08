import 'package:flutter/material.dart';
import 'block_overflow.dart';

class BaseBlock extends StatelessWidget {
  final Widget child;
  final BlockOverflowMode overflowMode;
  final double width;

  const BaseBlock({
    super.key,
    required this.child,
    this.overflowMode = BlockOverflowMode.clip,
    this.width = 320,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: overflowMode == BlockOverflowMode.scroll
            ? SingleChildScrollView(child: child)
            : child,
      ),
    );
  }
}
