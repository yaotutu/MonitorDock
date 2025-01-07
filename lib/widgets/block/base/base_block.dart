import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'block_overflow.dart';

class BaseBlock extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? secondaryView;
  final BlockOverflowMode overflowMode;
  final Duration flipDuration;
  final double width;

  const BaseBlock({
    super.key,
    required this.title,
    required this.child,
    this.secondaryView,
    this.overflowMode = BlockOverflowMode.clip,
    this.flipDuration = const Duration(milliseconds: 800),
    this.width = 320,
  });

  @override
  State<BaseBlock> createState() => _BaseBlockState();
}

class _BaseBlockState extends State<BaseBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.flipDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleView() {
    if (widget.secondaryView == null) return;
    if (_controller.isAnimating) return;

    if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget _buildBaseView({required Widget child}) {
    return Container(
      width: widget.width,
      constraints: const BoxConstraints(minHeight: 200),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.overflowMode == BlockOverflowMode.scroll
                  ? SingleChildScrollView(child: child)
                  : child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final frontView = _buildBaseView(child: widget.child);

    if (widget.secondaryView == null) {
      return frontView;
    }

    return GestureDetector(
      onTap: _toggleView,
      child: SizedBox(
        width: widget.width,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final angle = _animation.value * math.pi;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: angle < math.pi / 2
                  ? frontView
                  : Transform(
                      transform: Matrix4.identity()..rotateY(math.pi),
                      alignment: Alignment.center,
                      child: _buildBaseView(child: widget.secondaryView!),
                    ),
            );
          },
        ),
      ),
    );
  }
}
