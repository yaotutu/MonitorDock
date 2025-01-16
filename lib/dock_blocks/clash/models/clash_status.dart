class ClashTraffic {
  final int up; // 上行速率 (字节/秒)
  final int down; // 下行速率 (字节/秒)

  ClashTraffic({required this.up, required this.down});

  factory ClashTraffic.fromJson(Map<String, dynamic> json) {
    return ClashTraffic(
      up: (json['up'] as num?)?.toInt() ?? 0,
      down: (json['down'] as num?)?.toInt() ?? 0,
    );
  }

  String get upSpeed => _formatSpeed(up);
  String get downSpeed => _formatSpeed(down);

  String _formatSpeed(int bytesPerSecond) {
    if (bytesPerSecond < 1024) {
      return '$bytesPerSecond B/s';
    } else if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
  }
}

class ClashMemory {
  final int inuse; // 使用中的内存 (字节)
  final int total; // 总内存 (字节)

  ClashMemory({required this.inuse, required this.total});

  factory ClashMemory.fromJson(Map<String, dynamic> json) {
    return ClashMemory(
      inuse: (json['inuse'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 1,
    );
  }

  String get usageString =>
      '${(inuse / (1024 * 1024)).toStringAsFixed(1)}MB / ${(total / (1024 * 1024)).toStringAsFixed(1)}MB';

  double get usagePercentage => total > 0 ? inuse / total : 0.0;
}
