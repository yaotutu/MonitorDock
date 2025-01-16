class ClashTraffic {
  final int uploadTotal; // 总上传流量
  final int downloadTotal; // 总下载流量
  final int upload; // 当前上传速度
  final int download; // 当前下载速度

  ClashTraffic({
    required this.uploadTotal,
    required this.downloadTotal,
    required this.upload,
    required this.download,
  });

  factory ClashTraffic.fromJson(Map<String, dynamic> json) {
    return ClashTraffic(
      uploadTotal: json['uploadTotal'] ?? 0,
      downloadTotal: json['downloadTotal'] ?? 0,
      upload: json['up'] ?? 0,
      download: json['down'] ?? 0,
    );
  }
}
