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
    final gridConfig = GridMetrics.getConfiguration(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(gridConfig.edgeInsets),
        child: Wrap(
          spacing: gridConfig.spacing,
          runSpacing: gridConfig.spacing,
          children: children.map((item) {
            // 根据组件占用的1x1单位数计算实际尺寸
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

/// 网格参考线浮层
class GridLinesOverlay extends StatelessWidget {
  final GridConfiguration config;

  const GridLinesOverlay({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridLinesPainter(
        config: config,
        color: Colors.blue.withOpacity(0.1),
      ),
    );
  }
}

/// 网格线绘制器
class GridLinesPainter extends CustomPainter {
  final GridConfiguration config;
  final Color color;

  GridLinesPainter({
    required this.config,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final cellSize = config.cellSize;
    final spacing = config.spacing;
    final edgeInsets = config.edgeInsets;

    // 绘制垂直线
    for (int i = 0; i <= config.columnCount; i++) {
      final x = edgeInsets + i * (cellSize + spacing);
      canvas.drawLine(
        Offset(x, edgeInsets),
        Offset(x, size.height - edgeInsets),
        paint,
      );
    }

    // 绘制水平线
    for (int i = 0; i <= config.rowCount; i++) {
      final y = edgeInsets + i * (cellSize + spacing);
      canvas.drawLine(
        Offset(edgeInsets, y),
        Offset(size.width - edgeInsets, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GridLinesPainter oldDelegate) {
    return oldDelegate.config != config || oldDelegate.color != color;
  }
}

// 用于计算最大值的辅助函数
