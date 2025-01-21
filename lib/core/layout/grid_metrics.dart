import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 网格布局度量计算工具
class GridMetrics {
  /// 默认的网格列数
  static const int defaultColumnCount = 4;

  /// 默认的网格行数
  static const int defaultRowCount = 5;

  /// 默认的网格间距
  static const double defaultSpacing = 16.0;

  /// 边缘间距
  static const double defaultEdgeInsets = 16.0;

  /// 最小的单元格尺寸
  static const double minCellSize = 56.0;

  /// 最大的单元格尺寸
  static const double maxCellSize = 120.0;

  /// 计算基准单元格尺寸
  ///
  /// [context] - 构建上下文，用于获取屏幕尺寸
  /// [columnCount] - 列数，默认为4
  /// [rowCount] - 行数，默认为5
  /// [spacing] - 网格间距，默认为16.0
  /// 返回计算后的单元格尺寸
  static double calculateBaseCellSize(
    BuildContext context, {
    int columnCount = defaultColumnCount,
    int rowCount = defaultRowCount,
    double spacing = defaultSpacing,
  }) {
    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;

    // 计算实际可用空间（减去安全区域和边缘间距）
    final availableWidth =
        screenSize.width - safeArea.horizontal - (defaultEdgeInsets * 2);
    final availableHeight =
        screenSize.height - safeArea.vertical - (defaultEdgeInsets * 2);

    // 计算网格总间距
    final horizontalSpacingTotal = spacing * (columnCount - 1);
    final verticalSpacingTotal = spacing * (rowCount - 1);

    // 计算单元格尺寸
    final cellWidth = (availableWidth - horizontalSpacingTotal) / columnCount;
    final cellHeight = (availableHeight - verticalSpacingTotal) / rowCount;

    // 使用较小的尺寸确保单元格是正方形
    return math.min(cellWidth, cellHeight);
  }

  /// 根据屏幕尺寸计算推荐的网格配置
  ///
  /// [context] - 构建上下文，用于获取屏幕尺寸
  /// 返回推荐的网格配置
  static GridConfiguration calculateRecommendedGrid(BuildContext context) {
    final cellSize = calculateBaseCellSize(context);

    return GridConfiguration(
      columnCount: defaultColumnCount,
      rowCount: defaultRowCount,
      cellSize: cellSize,
      spacing: defaultSpacing,
      edgeInsets: defaultEdgeInsets,
    );
  }

  /// 计算给定尺寸在当前配置下的实际像素尺寸
  static Size calculateActualSize(BuildContext context, int columns, int rows) {
    final config = calculateRecommendedGrid(context);
    return Size(
      config.calculateWidth(columns),
      config.calculateHeight(rows),
    );
  }
}

/// 网格配置数据类
class GridConfiguration {
  final int columnCount;
  final int rowCount;
  final double cellSize;
  final double spacing;
  final double edgeInsets;

  const GridConfiguration({
    required this.columnCount,
    required this.rowCount,
    required this.cellSize,
    required this.spacing,
    required this.edgeInsets,
  });

  /// 计算给定尺寸组件的实际宽度（包含间距）
  double calculateWidth(int columns) {
    if (columns <= 0) return 0;
    return columns * cellSize + (columns - 1) * spacing;
  }

  /// 计算给定尺寸组件的实际高度（包含间距）
  double calculateHeight(int rows) {
    if (rows <= 0) return 0;
    return rows * cellSize + (rows - 1) * spacing;
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
