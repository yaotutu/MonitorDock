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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      padding: padding,
      decoration: decoration ??
          BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withAlpha(128),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha(13),
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            _buildTitle(context),
            Divider(
              height: 1,
              thickness: 0.5,
              color: colorScheme.outline.withAlpha(128),
            ),
          ],
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  /// 构建标题组件
  Widget _buildTitle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title!,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 构建内容区域
  Widget _buildContent(BuildContext context) {
    Widget content = _buildMainContent(context);

    // 根据不同的溢出模式处理内容
    switch (overflowMode) {
      case BlockOverflowMode.scroll:
        return enableHorizontalScroll
            ? ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(
                  scrollbars: false,
                  physics: physics ?? const BouncingScrollPhysics(),
                ),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: content,
                  ),
                ),
              )
            : ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(
                  scrollbars: false,
                  physics: physics ?? const BouncingScrollPhysics(),
                ),
                child: SingleChildScrollView(
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
  Widget _buildMainContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
              ),
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
