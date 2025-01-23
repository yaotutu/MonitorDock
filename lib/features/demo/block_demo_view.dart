import 'package:flutter/material.dart';
import '../../core/blocks/base_block.dart';
import '../../core/layout/nested_grid.dart';

class BlockDemoView extends StatelessWidget {
  const BlockDemoView({super.key});

  Widget _buildBlockContent(BuildContext context, Color color, GridSize size) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '${size.width}x${size.height}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainGrid = NestedGrid(
      columns: 8,  // 使用8列布局
      rows: 4,     // 使用4行布局
      padding: const EdgeInsets.all(8),
      spacing: 8,
      items: [
        // 4x4 的主监控面板
        NestedGridItem(
          size: GridSize.size4x4,
          position: const GridPosition(0, 0),  // 左上角
          child: NestedGrid(
            columns: 4,  // 内部使用4列布局
            rows: 4,     // 内部使用4行布局
            spacing: 8,
            items: [
              // 2x2 的系统信息块
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(0, 0),  // 左上
                child: BaseBlock(
                  config: BlockConfig(
                    id: 'system_1',
                    type: BlockType.system,
                    size: GridSize.size2x2,
                  ),
                  buildBlockContent: (context) => _buildBlockContent(
                    context,
                    Colors.blue[100]!,
                    GridSize.size2x2,
                  ),
                ),
              ),
              // 2x2 的网络监控块
              NestedGridItem(
                size: GridSize.size2x2,
                position: const GridPosition(2, 0),  // 右上
                child: BaseBlock(
                  config: BlockConfig(
                    id: 'network_1',
                    type: BlockType.network,
                    size: GridSize.size2x2,
                  ),
                  buildBlockContent: (context) => _buildBlockContent(
                    context,
                    Colors.green[100]!,
                    GridSize.size2x2,
                  ),
                ),
              ),
              // 4x1 的天气信息块
              NestedGridItem(
                size: GridSize.size4x1,
                position: const GridPosition(0, 2),  // 底部
                child: BaseBlock(
                  config: BlockConfig(
                    id: 'weather_1',
                    type: BlockType.weather,
                    size: GridSize.size4x1,
                  ),
                  buildBlockContent: (context) => _buildBlockContent(
                    context,
                    Colors.orange[100]!,
                    GridSize.size4x1,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 2x2 的独立系统信息块
        NestedGridItem(
          size: GridSize.size2x2,
          position: const GridPosition(4, 0),  // 右侧
          child: BaseBlock(
            config: BlockConfig(
              id: 'system_2',
              type: BlockType.system,
              size: GridSize.size2x2,
            ),
            buildBlockContent: (context) => _buildBlockContent(
              context,
              Colors.purple[100]!,
              GridSize.size2x2,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('块布局演示'),
      ),
      body: mainGrid,
    );
  }
}
