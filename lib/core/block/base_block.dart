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
  final Widget? expandedContent;
  final ContentFitMode contentFit;
  final double width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;

  const BaseBlock({
    super.key,
    required this.child,
    this.expandedContent,
    this.contentFit = ContentFitMode.scroll,
    this.width = AppMetrics.defaultBlockWidth,
    this.height,
    this.padding = const EdgeInsets.all(AppMetrics.blockPadding),
    this.backgroundColor,
    this.borderColor,
  });

  void _showExpandedView(BuildContext context) {
    if (expandedContent == null) return;

    final size = MediaQuery.of(context).size;
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        width: size.width * 0.9,
        height: size.height * 0.9,
        margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.05,
        ),
        decoration: BoxDecoration(
          color: AppColors.getContainerColor(isDark),
          borderRadius: BorderRadius.circular(AppMetrics.blockRadius),
          border: Border.all(
            color: AppColors.getBorderColor(isDark),
            width: AppMetrics.borderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppMetrics.blockRadius),
          child: Stack(
            children: [
              expandedContent!,
              Positioned(
                top: 8,
                right: 8,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          AppColors.getContainerColor(isDark).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.getBorderColor(isDark),
                        width: AppMetrics.borderWidth,
                      ),
                    ),
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 16,
                      color: isDark
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return GestureDetector(
      onTap: () => _showExpandedView(context),
      child: ClipRRect(
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
