import 'package:flutter/material.dart';

/// 网格布局度量计算工具
class GridMetrics {
  /// 竖屏时的默认列数
  static const int defaultPortraitColumnCount = 4;

  /// 竖屏时的默认行数
  static const int defaultPortraitRowCount = 5;

  /// 横屏时的默认列数
  static const int defaultLandscapeColumnCount = 6;

  /// 横屏时的默认行数
  static const int defaultLandscapeRowCount = 4;

  /// 组件之间的间距
  static const double defaultSpacing = 16.0;

  /// 边缘间距
  static const double defaultEdgeInsets = 16.0;

  /// 计算1x1组件的基准尺寸
  static double calculateBaseUnitSize(BuildContext context) {
    // 获取屏幕尺寸和方向
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // 根据屏幕方向选择行列数
    final columnCount = isPortrait ? defaultPortraitColumnCount : defaultLandscapeColumnCount;
    final rowCount = isPortrait ? defaultPortraitRowCount : defaultLandscapeRowCount;

    // 计算实际可用宽度和高度（减去安全区域和边缘间距）
    final availableWidth =
        screenSize.width - safeArea.horizontal - (defaultEdgeInsets * 2);
    final availableHeight =
        screenSize.height - safeArea.vertical - (defaultEdgeInsets * 2);

    // 计算水平和垂直方向的总间距
    final horizontalSpacingTotal = defaultSpacing * (columnCount - 1);
    final verticalSpacingTotal = defaultSpacing * (rowCount - 1);

    // 分别计算基于宽度和高度的单位尺寸
    final widthBasedSize = (availableWidth - horizontalSpacingTotal) / columnCount;
    final heightBasedSize = (availableHeight - verticalSpacingTotal) / rowCount;

    // 返回较小的值，确保网格能完整显示
    return widthBasedSize < heightBasedSize ? widthBasedSize : heightBasedSize;
  }

  /// 获取网格配置
  static GridConfiguration getConfiguration(BuildContext context) {
    final baseUnitSize = calculateBaseUnitSize(context);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return GridConfiguration(
      columnCount: isPortrait ? defaultPortraitColumnCount : defaultLandscapeColumnCount,
      rowCount: isPortrait ? defaultPortraitRowCount : defaultLandscapeRowCount,
      baseUnitSize: baseUnitSize,
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
