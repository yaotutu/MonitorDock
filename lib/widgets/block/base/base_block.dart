import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
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
      constraints: const BoxConstraints(
        minHeight: double.infinity,
      ),
      decoration: Theme.of(context).cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: overflowMode == BlockOverflowMode.scroll
            ? SingleChildScrollView(child: child)
            : child,
      ),
    );
  }
}
