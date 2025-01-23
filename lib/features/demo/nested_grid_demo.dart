import 'package:flutter/material.dart';
import '../../core/layout/nested_grid.dart';

class NestedGridDemo extends StatelessWidget {
  const NestedGridDemo({super.key});

  Widget _buildGridItem(GridSize size, Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${size.width}x${size.height}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('网格布局演示'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NestedGrid(
          columns: isLandscape ? 8 : 4,
          rows: isLandscape ? 4 : 6,
          spacing: 8,
          items: [
            if (isLandscape) ...[
              // 左侧状态列（4个1x1）
              for (int i = 0; i < 4; i++)
                NestedGridItem(
                  size: GridSize.size1x1,
                  position: GridPosition(0, i),
                  child: _buildGridItem(
                    GridSize.size1x1,
                    Colors.blue[(i + 1) * 100]!,
                    '状态${i + 1}',
                  ),
                ),

              // 左侧监控区（2个2x2）
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(1, 0),
                child: _buildGridItem(
                  GridSize.size2x2,
                  Colors.green[100]!,
                  '监控1',
                ),
              ),
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(1, 2),
                child: _buildGridItem(
                  GridSize.size2x2,
                  Colors.green[200]!,
                  '监控2',
                ),
              ),

              // 右侧顶部状态栏
              NestedGridItem(
                size: GridSize.size4x1,
                position: const GridPosition(4, 0),
                child: _buildGridItem(
                  GridSize.size4x1,
                  Colors.purple[100]!,
                  '系统状态',
                ),
              ),

              // 右侧监控区（2个2x2）
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(4, 1),
                child: _buildGridItem(
                  GridSize.size2x2,
                  Colors.orange[100]!,
                  '内存使用',
                ),
              ),
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(6, 1),
                child: _buildGridItem(
                  GridSize.size2x2,
                  Colors.orange[200]!,
                  'CPU使用',
                ),
              ),

              // 右侧底部状态栏
              NestedGridItem(
                size: GridSize.size4x1,
                position: const GridPosition(4, 3),
                child: _buildGridItem(
                  GridSize.size4x1,
                  Colors.teal[100]!,
                  '告警信息',
                ),
              ),
            ] else ...[
              // 顶部状态栏
              NestedGridItem(
                size: GridSize.size4x1,
                position: const GridPosition(0, 0),
                child: _buildGridItem(
                  GridSize.size4x1,
                  Colors.blue[100]!,
                  '系统状态',
                ),
              ),

              // 左侧状态列
              for (int i = 0; i < 4; i++)
                NestedGridItem(
                  size: GridSize.size1x1,
                  position: GridPosition(0, i + 1),
                  child: _buildGridItem(
                    GridSize.size1x1,
                    Colors.green[(i + 1) * 100]!,
                    '状态${i + 1}',
                  ),
                ),

              // 右侧监控区
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(2, 1),
                child: _buildGridItem(
                  GridSize.size2x2,
                  Colors.orange[100]!,
                  '监控1',
                ),
              ),
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(2, 3),
                child: _buildGridItem(
                  GridSize.size2x2,
                  Colors.orange[200]!,
                  '监控2',
                ),
              ),

              // 底部状态栏
              NestedGridItem(
                size: GridSize.size4x1,
                position: const GridPosition(0, 5),
                child: _buildGridItem(
                  GridSize.size4x1,
                  Colors.purple[100]!,
                  '告警信息',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
