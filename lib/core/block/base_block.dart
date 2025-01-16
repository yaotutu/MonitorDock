import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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

  const BaseBlock({
    super.key,
    required this.child,
    this.contentFit = ContentFitMode.scroll,
    this.width = 320,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: const BoxConstraints(
        minHeight: 100, // 设置最小高度以确保始终有显示空间
      ),
      decoration: Theme.of(context).cardDecoration,
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
