import 'package:flutter/material.dart';
import 'block_overflow.dart';

class BaseBlock extends StatelessWidget {
  final double width;
  final Color? backgroundColor;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final String? title;
  final bool isLoading;
  final String? errorMessage;
  final BlockOverflowMode overflowMode;
  final ScrollPhysics? physics;
  final bool enableHorizontalScroll;

  const BaseBlock({
    super.key,
    this.width = 200,
    this.backgroundColor,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.decoration,
    this.title,
    this.isLoading = false,
    this.errorMessage,
    this.overflowMode = BlockOverflowMode.scroll,
    this.physics,
    this.enableHorizontalScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            _buildTitle(),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title!,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget content = _buildMainContent();

    switch (overflowMode) {
      case BlockOverflowMode.scroll:
        return enableHorizontalScroll
            ? ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                ),
                child: SingleChildScrollView(
                  physics: physics ?? const BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: physics ?? const BouncingScrollPhysics(),
                    child: content,
                  ),
                ),
              )
            : ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                ),
                child: SingleChildScrollView(
                  physics: physics ?? const BouncingScrollPhysics(),
                  child: content,
                ),
              );
      case BlockOverflowMode.clip:
        return ClipRect(child: content);
      case BlockOverflowMode.visible:
        return content;
    }
  }

  Widget _buildMainContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      );
    }

    return child;
  }
}
