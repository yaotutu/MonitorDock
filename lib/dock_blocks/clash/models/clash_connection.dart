class ClashConnection {
  final String id;
  final String sourceIP;
  final String host;
  final int upload;
  final int download;
  final DateTime start;

  // 用于计算速度的字段
  int? _lastUpload;
  int? _lastDownload;
  DateTime? _lastUpdateTime;
  double uploadSpeed = 0;
  double downloadSpeed = 0;

  ClashConnection({
    required this.id,
    required this.sourceIP,
    required this.host,
    required this.upload,
    required this.download,
    required this.start,
  });

  factory ClashConnection.fromJson(Map<String, dynamic> json) {
    return ClashConnection(
      id: json['id'] as String,
      sourceIP: json['metadata']['sourceIP'] as String,
      host: json['metadata']['host'] as String,
      upload: json['upload'] as int,
      download: json['download'] as int,
      start: DateTime.parse(json['start'] as String),
    );
  }

  void updateSpeed(ClashConnection lastConn) {
    final now = DateTime.now();
    if (lastConn._lastUpdateTime != null) {
      final timeDiff = now.difference(lastConn._lastUpdateTime!).inMilliseconds;
      if (timeDiff > 0) {
        // 计算上传和下载的字节差
        final uploadDiff = upload - (lastConn._lastUpload ?? upload);
        final downloadDiff = download - (lastConn._lastDownload ?? download);

        // 转换为每秒的速度 (bytes/s)
        uploadSpeed = (uploadDiff * 1000 / timeDiff).abs();
        downloadSpeed = (downloadDiff * 1000 / timeDiff).abs();
      }
    }

    _lastUpload = upload;
    _lastDownload = download;
    _lastUpdateTime = now;
  }
}

class ClashTrafficData {
  final int downloadTotal;
  final int uploadTotal;
  final List<ClashConnection> connections;
  final int memory;

  ClashTrafficData({
    required this.downloadTotal,
    required this.uploadTotal,
    required this.connections,
    required this.memory,
  });

  factory ClashTrafficData.fromJson(Map<String, dynamic> json) {
    return ClashTrafficData(
      downloadTotal: json['downloadTotal'] as int,
      uploadTotal: json['uploadTotal'] as int,
      connections: (json['connections'] as List)
          .map((e) => ClashConnection.fromJson(e as Map<String, dynamic>))
          .toList(),
      memory: json['memory'] as int,
    );
  }
}
