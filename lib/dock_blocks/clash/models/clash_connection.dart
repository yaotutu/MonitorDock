class ClashConnection {
  final String id;
  final String host;
  final String destinationIP;
  final String sourceIP;
  final String network;
  final String type;
  final int upload;
  final int download;
  final List<String> chains;
  final String rule;
  final String rulePayload;
  final DateTime startTime;

  ClashConnection({
    required this.id,
    required this.host,
    required this.destinationIP,
    required this.sourceIP,
    required this.network,
    required this.type,
    required this.upload,
    required this.download,
    required this.chains,
    required this.rule,
    required this.rulePayload,
    required this.startTime,
  });

  factory ClashConnection.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>;
    return ClashConnection(
      id: json['id']?.toString() ?? '',
      host: metadata['host']?.toString() ?? 'Unknown',
      destinationIP: metadata['destinationIP']?.toString() ?? '',
      sourceIP: metadata['sourceIP']?.toString() ?? '',
      network: metadata['network']?.toString() ?? 'Unknown',
      type: metadata['type']?.toString() ?? 'Unknown',
      upload: (json['upload'] as num?)?.toInt() ?? 0,
      download: (json['download'] as num?)?.toInt() ?? 0,
      chains: (json['chains'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rule: json['rule']?.toString() ?? 'Unknown',
      rulePayload: json['rulePayload']?.toString() ?? '',
      startTime:
          DateTime.tryParse(json['start']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  String get totalTraffic => _formatBytes(upload + download);
  String get uploadSpeed => _formatBytes(upload);
  String get downloadSpeed => _formatBytes(download);
  String get chainString => chains.join(' → ');

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
