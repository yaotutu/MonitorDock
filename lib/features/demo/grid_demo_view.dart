import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/layout/grid_flow.dart';
import '../../core/layout/grid_metrics.dart';

class GridDemoView extends StatelessWidget {
  const GridDemoView({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取推荐的网格配置
    final gridConfig = GridMetrics.getConfiguration(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 网格布局
            Positioned.fill(
              child: GridFlow(
                children: [
                  // Huge 示例 (4x4)
                  GridItem(
                    size: GridItemSize.huge,
                    child: DemoItemWidget(
                      text: 'Huge\n4x4\n${_calculateSize(4, 4, gridConfig)}',
                      color: Colors.blue[100]!,
                    ),
                  ),
                  // Tiny 示例 (1x1)
                  GridItem(
                    size: GridItemSize.tiny,
                    child: DemoItemWidget(
                      text: 'Tiny\n1x1\n${_calculateSize(1, 1, gridConfig)}',
                      color: Colors.red[100]!,
                    ),
                  ),
                  // Small 示例 (2x1)
                  GridItem(
                    size: GridItemSize.small,
                    child: DemoItemWidget(
                      text: 'Small\n2x1\n${_calculateSize(2, 1, gridConfig)}',
                      color: Colors.green[100]!,
                    ),
                  ),
                  // Tall 示例 (1x2)
                  GridItem(
                    size: GridItemSize.tall,
                    child: DemoItemWidget(
                      text: 'Tall\n1x2\n${_calculateSize(1, 2, gridConfig)}',
                      color: Colors.orange[100]!,
                    ),
                  ),
                  // Medium 示例 (2x2)
                  GridItem(
                    size: GridItemSize.medium,
                    child: DemoItemWidget(
                      text: 'Medium\n2x2\n${_calculateSize(2, 2, gridConfig)}',
                      color: Colors.purple[100]!,
                    ),
                  ),
                  // Wide 示例 (4x1)
                  GridItem(
                    size: GridItemSize.wide,
                    child: DemoItemWidget(
                      text: 'Wide\n4x1\n${_calculateSize(4, 1, gridConfig)}',
                      color: Colors.teal[100]!,
                    ),
                  ),
                  // Large 示例 (4x2)
                  GridItem(
                    size: GridItemSize.large,
                    child: DemoItemWidget(
                      text: 'Large\n4x2\n${_calculateSize(4, 2, gridConfig)}',
                      color: Colors.pink[100]!,
                    ),
                  ),
                ],
              ),
            ),

            // 布局信息浮层
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '网格配置',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '列数：${gridConfig.columnCount}\n'
                      '行数：${gridConfig.rowCount}\n'
                      '单元格：${gridConfig.baseUnitSize.toStringAsFixed(1)}px\n'
                      '间距：${gridConfig.spacing}px',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateSize(int columns, int rows, GridConfiguration config) {
    final width = config.calculateWidth(columns);
    final height = config.calculateHeight(rows);
    return '${width.toStringAsFixed(0)}x${height.toStringAsFixed(0)}';
  }
}

class DemoItemWidget extends StatelessWidget {
  final String text;
  final Color color;

  const DemoItemWidget({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
