import 'package:flutter/material.dart';

/// 网格位置
class GridPosition {
  final int column;
  final int row;

  const GridPosition(this.column, this.row);
}

/// 网格大小
class GridSize {
  final int width;
  final int height;

  const GridSize(this.width, this.height);

  // 常用大小
  static const size1x1 = GridSize(1, 1);
  static const size2x2 = GridSize(2, 2);
  static const size4x1 = GridSize(4, 1);
  static const size4x2 = GridSize(4, 2);
  static const size4x4 = GridSize(4, 4);
}

/// 网格项
class NestedGridItem extends StatelessWidget {
  final GridSize size;
  final GridPosition position;
  final Widget child;

  const NestedGridItem({
    super.key,
    required this.size,
    required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => child;
}

/// 网格布局
class NestedGrid extends StatelessWidget {
  final int columns;
  final int rows;
  final List<NestedGridItem> items;
  final double spacing;
  final EdgeInsets padding;

  const NestedGrid({
    super.key,
    required this.columns,
    required this.rows,
    required this.items,
    this.spacing = 0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - padding.horizontal;
        final availableHeight = constraints.maxHeight - padding.vertical;

        final unitWidth = (availableWidth - spacing * (columns - 1)) / columns;
        final unitHeight = (availableHeight - spacing * (rows - 1)) / rows;

        return Padding(
          padding: padding,
          child: SizedBox(
            width: availableWidth,
            height: availableHeight,
            child: Stack(
              children: items.map((item) {
                final width = item.size.width * unitWidth + spacing * (item.size.width - 1);
                final height = item.size.height * unitHeight + spacing * (item.size.height - 1);

                return Positioned(
                  left: item.position.column * (unitWidth + spacing),
                  top: item.position.row * (unitHeight + spacing),
                  width: width,
                  height: height,
                  child: item.child,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
