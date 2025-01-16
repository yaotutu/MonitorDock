import 'package:flutter/material.dart';

/// 内容适配模式
enum ContentFitMode {
  /// 允许内容滚动（默认）
  scroll,

  /// 等比缩放内容以适应容器
  scale,

  /// 裁剪溢出内容
  clip,
}

class BaseBlock extends StatelessWidget {
  final Widget child;
  final ContentFitMode contentFit;
  final double width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;

  const BaseBlock({
    super.key,
    required this.child,
    this.contentFit = ContentFitMode.scroll,
    this.width = 320,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Container(
      width: width,
      height: height,
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? (isDark ? Colors.white24 : Colors.black12),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black26 : Colors.black12).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (contentFit) {
      case ContentFitMode.scroll:
        return SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: child,
          ),
        );
      case ContentFitMode.scale:
        return FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: padding,
            child: child,
          ),
        );
      case ContentFitMode.clip:
        return Padding(
          padding: padding,
          child: child,
        );
    }
  }
}
