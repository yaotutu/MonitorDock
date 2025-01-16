class ServerStatus {
  final String status;
  final String uptime;
  final String memory;
  final String cpu;

  const ServerStatus({
    required this.status,
    required this.uptime,
    required this.memory,
    required this.cpu,
  });

  factory ServerStatus.fromJson(Map<String, dynamic> json) {
    return ServerStatus(
      status: json['status'] as String,
      uptime: json['uptime'] as String,
      memory: json['memory'] as String,
      cpu: json['cpu'] as String,
    );
  }
}
