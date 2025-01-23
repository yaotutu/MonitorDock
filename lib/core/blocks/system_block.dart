import 'package:flutter/material.dart';
import 'base_block.dart';
import '../layout/nested_grid.dart';

/// 系统信息数据
class SystemBlockData extends BlockData {
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final String osVersion;

  const SystemBlockData({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.osVersion,
  });
}

/// 系统信息块
class SystemBlock extends BaseBlock {
  SystemBlock({
    super.key,
    required String id,
    required GridSize size,
    SystemBlockData? data,
    List<BaseBlock>? children,
  }) : super(
          config: BlockConfig(
            id: id,
            type: BlockType.system,
            size: size,
          ),
          data: data,
          children: children,
          buildBlockContent: (context) {
            final blockData = data;
            if (blockData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem(
                  icon: Icons.memory,
                  label: 'CPU使用率',
                  value: '${(blockData.cpuUsage * 100).toStringAsFixed(1)}%',
                  progress: blockData.cpuUsage,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.storage,
                  label: '内存使用率',
                  value: '${(blockData.memoryUsage * 100).toStringAsFixed(1)}%',
                  progress: blockData.memoryUsage,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.disc_full,
                  label: '磁盘使用率',
                  value: '${(blockData.diskUsage * 100).toStringAsFixed(1)}%',
                  progress: blockData.diskUsage,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.computer,
                  label: '系统版本',
                  value: blockData.osVersion,
                ),
              ],
            );
          },
        );

  @override
  void updateData(BlockData newData) {
    // 在实际应用中，这里会触发状态更新
  }
}

Widget _buildInfoItem({
  required IconData icon,
  required String label,
  required String value,
  double? progress,
}) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.8
                      ? Colors.red
                      : progress > 0.6
                          ? Colors.orange
                          : Colors.blue,
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}
