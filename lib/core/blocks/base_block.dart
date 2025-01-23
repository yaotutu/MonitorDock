import 'package:flutter/material.dart';
import '../layout/nested_grid.dart';

/// 块的类型枚举
enum BlockType {
  clock,      // 时钟块
  weather,    // 天气块
  system,     // 系统信息块
  network,    // 网络监控块
  custom,     // 自定义块
}

/// 基础数据接口
abstract class BlockData {
  const BlockData();
}

/// 基础块配置
class BlockConfig {
  final String id;
  final BlockType type;
  final GridSize size;
  final Map<String, dynamic>? extraConfig;

  const BlockConfig({
    required this.id,
    required this.type,
    required this.size,
    this.extraConfig,
  });
}

/// 基础块组件
class BaseBlock extends StatefulWidget {
  final BlockConfig config;
  final BlockData? data;
  final List<BaseBlock>? children;
  final Widget Function(BuildContext context)? buildBlockContent;

  const BaseBlock({
    super.key,
    required this.config,
    this.data,
    this.children,
    this.buildBlockContent,
  });

  @override
  State<BaseBlock> createState() => _BaseBlockState();

  /// 更新块的数据
  void updateData(BlockData newData) {
    // 在实际应用中，这里会触发状态更新
  }
}

class _BaseBlockState extends State<BaseBlock> {
  @override
  Widget build(BuildContext context) {
    return NestedGridItem(
      size: widget.config.size,
      position: const GridPosition(0, 0), // 默认位置，应该由父组件指定
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.children != null
            ? NestedGrid(
                columns: 4, // 默认4列
                rows: 4,   // 默认4行
                padding: EdgeInsets.zero,
                spacing: 8,
                items: widget.children!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final block = entry.value;
                  // 计算位置：每个子块按顺序放置
                  final row = index ~/ 2;
                  final col = index % 2;
                  return NestedGridItem(
                    size: block.config.size,
                    position: GridPosition(col * 2, row * 2),
                    child: block,
                  );
                }).toList(),
              )
            : widget.buildBlockContent?.call(context) ?? const SizedBox(),
      ),
    );
  }
}
