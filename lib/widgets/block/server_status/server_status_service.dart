import 'models/server_status.dart';

class ServerStatusService {
  Future<ServerStatus> fetchStatus() async {
    // 模拟API调用
    await Future.delayed(const Duration(seconds: 2));

    return ServerStatus(
      status: 'running',
      uptime: '99.9%',
      memory: '65%',
      cpu: '45%',
    );
  }
}
