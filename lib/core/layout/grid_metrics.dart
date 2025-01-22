import 'package:flutter/material.dart';

/// 网格布局度量计算工具
class GridMetrics {
  /// 桌面网格的总列数（横向最多可以放几个1x1的组件）
  static const int defaultColumnCount = 4;

  /// 桌面网格的总行数（纵向最多可以放几个1x1的组件）
  static const int defaultRowCount = 5;

  /// 组件之间的间距
  static const double defaultSpacing = 16.0;

  /// 边缘间距
  static const double defaultEdgeInsets = 16.0;

  /// 计算1x1组件的基准尺寸
  ///
  /// 整个屏幕会被划分为 4x5 的网格，每个格子就是一个1x1组件的大小
  /// 这个方法会计算出每个1x1格子的实际像素尺寸
  static double calculateBaseUnitSize(BuildContext context) {
    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;

    // 计算实际可用宽度（减去安全区域和边缘间距）
    final availableWidth =
        screenSize.width - safeArea.horizontal - (defaultEdgeInsets * 2);

    // 计算水平方向的总间距
    final horizontalSpacingTotal = defaultSpacing * (defaultColumnCount - 1);

    // 基于宽度计算1x1的尺寸（宽度优先）
    // 可用宽度减去所有间距，然后平均分配给4列
    return (availableWidth - horizontalSpacingTotal) / defaultColumnCount;
  }

  /// 获取网格配置
  static GridConfiguration getConfiguration(BuildContext context) {
    final baseUnitSize = calculateBaseUnitSize(context);

    return GridConfiguration(
      columnCount: defaultColumnCount, // 横向4个1x1
      rowCount: defaultRowCount, // 纵向5个1x1
      baseUnitSize: baseUnitSize, // 1x1的实际像素尺寸
      spacing: defaultSpacing,
      edgeInsets: defaultEdgeInsets,
    );
  }
}

/// 网格配置数据类
class GridConfiguration {
  /// 横向最多可以放几个1x1的组件
  final int columnCount;

  /// 纵向最多可以放几个1x1的组件
  final int rowCount;

  /// 1x1组件的实际像素尺寸
  final double baseUnitSize;

  /// 组件之间的间距
  final double spacing;

  /// 边缘间距
  final double edgeInsets;

  const GridConfiguration({
    required this.columnCount,
    required this.rowCount,
    required this.baseUnitSize,
    required this.spacing,
    required this.edgeInsets,
  });

  /// 计算指定宽度（以1x1为单位）的实际像素宽度
  double calculateWidth(int units) {
    if (units <= 0) return 0;
    // 实际宽度 = 单位数 * 基准尺寸 + (单位数-1) * 间距
    return units * baseUnitSize + (units - 1) * spacing;
  }

  /// 计算指定高度（以1x1为单位）的实际像素高度
  double calculateHeight(int units) {
    if (units <= 0) return 0;
    // 实际高度 = 单位数 * 基准尺寸 + (单位数-1) * 间距
    return units * baseUnitSize + (units - 1) * spacing;
  }

  /// 获取网格的总宽度（包含边距）
  double get totalWidth => edgeInsets * 2 + calculateWidth(columnCount);

  /// 获取网格的总高度（包含边距）
  double get totalHeight => edgeInsets * 2 + calculateHeight(rowCount);

  /// 获取可用区域的宽度（不包含边距）
  double get contentWidth => calculateWidth(columnCount);

  /// 获取可用区域的高度（不包含边距）
  double get contentHeight => calculateHeight(rowCount);
}
