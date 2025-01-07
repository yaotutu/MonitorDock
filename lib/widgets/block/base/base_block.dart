import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'block_overflow.dart';

/// 基础块组件
/// 用于创建统一样式的内容块，支持标题、加载状态、错误显示等
class BaseBlock extends StatelessWidget {
  final double width; // 块的宽度
  final Color? backgroundColor; // 背景色
  final Widget child; // 子组件
  final EdgeInsetsGeometry? padding; // 内边距
  final BoxDecoration? decoration; // 自定义装饰
  final String? title; // 标题
  final bool isLoading; // 是否正在加载
  final String? errorMessage; // 错误信息
  final BlockOverflowMode overflowMode; // 内容溢出处理模式
  final ScrollPhysics? physics; // 滚动物理效果
  final bool enableHorizontalScroll; // 是否启用水平滚动

  const BaseBlock({
    super.key,
    this.width = 280,
    this.backgroundColor,
    required this.child,
    this.padding = const EdgeInsets.all(16),
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
      decoration: decoration ?? AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            _buildTitle(),
            const Divider(color: AppTheme.outlineVariant),
          ],
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  /// 构建标题组件
  Widget _buildTitle() {
    return Text(
      title!,
      style: AppTheme.titleMedium,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 构建内容区域
  Widget _buildContent(BuildContext context) {
    Widget content = _buildMainContent();

    // 根据不同的溢出模式处理内容
    switch (overflowMode) {
      case BlockOverflowMode.scroll:
        return enableHorizontalScroll
            ? ScrollConfiguration(
                // 隐藏滚动条
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                ),
                // 支持水平和垂直滚动
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
                // 只支持垂直滚动
                child: SingleChildScrollView(
                  physics: physics ?? const BouncingScrollPhysics(),
                  child: content,
                ),
              );
      case BlockOverflowMode.clip:
        return ClipRect(child: content); // 裁剪溢出内容
      case BlockOverflowMode.visible:
        return content; // 显示溢出内容
    }
  }

  /// 构建主要内容
  Widget _buildMainContent() {
    // 显示加载状态
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
        ),
      );
    }

    // 显示错误信息
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.error),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      );
    }

    // 显示正常内容
    return child;
  }
}
