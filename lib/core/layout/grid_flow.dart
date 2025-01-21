import 'package:flutter/material.dart';

import 'grid_metrics.dart';

/// 网格布局组件尺寸枚举
enum GridItemSize {
  tiny, // 1x1
  small, // 2x1
  tall, // 1x2
  medium, // 2x2
  wide, // 4x1
  large, // 4x2
  huge // 4x4
}

/// 网格布局项配置
class GridItem {
  final Widget child;
  final GridItemSize size;

  const GridItem({
    required this.child,
    required this.size,
  });

  /// 获取组件占用的列数
  int get columnSpan {
    switch (size) {
      case GridItemSize.tiny:
        return 1;
      case GridItemSize.small:
        return 2;
      case GridItemSize.tall:
        return 1;
      case GridItemSize.medium:
        return 2;
      case GridItemSize.wide:
        return 4;
      case GridItemSize.large:
        return 4;
      case GridItemSize.huge:
        return 4;
    }
  }

  /// 获取组件占用的行数
  int get rowSpan {
    switch (size) {
      case GridItemSize.tiny:
        return 1;
      case GridItemSize.small:
        return 1;
      case GridItemSize.tall:
        return 2;
      case GridItemSize.medium:
        return 2;
      case GridItemSize.wide:
        return 1;
      case GridItemSize.large:
        return 2;
      case GridItemSize.huge:
        return 4;
    }
  }
}

/// 网格布局组件
class GridFlow extends StatelessWidget {
  final List<GridItem> children;

  const GridFlow({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // 获取网格配置
    final gridConfig = GridMetrics.calculateRecommendedGrid(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(gridConfig.edgeInsets),
        child: Wrap(
          spacing: gridConfig.spacing,
          runSpacing: gridConfig.spacing,
          children: children.map((item) {
            return SizedBox(
              width: gridConfig.calculateWidth(item.columnSpan),
              height: gridConfig.calculateHeight(item.rowSpan),
              child: item.child,
            );
          }).toList(),
        ),
      ),
    );
  }
}

// 用于计算最大值的辅助函数
