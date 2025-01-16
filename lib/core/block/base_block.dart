import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

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
    this.width = AppMetrics.defaultBlockWidth,
    this.height,
    this.padding = const EdgeInsets.all(AppMetrics.blockPadding),
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppMetrics.blockRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppMetrics.blurRadius,
          sigmaY: AppMetrics.blurRadius,
        ),
        child: Container(
          width: width,
          height: height,
          constraints: const BoxConstraints(
            minHeight: AppMetrics.minBlockHeight,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.getContainerColor(isDark),
            borderRadius: BorderRadius.circular(AppMetrics.blockRadius),
            border: Border.all(
              color: borderColor ?? AppColors.getBorderColor(isDark),
              width: AppMetrics.borderWidth,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (contentFit) {
      case ContentFitMode.scroll:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
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
