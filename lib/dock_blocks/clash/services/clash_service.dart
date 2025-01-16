import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../models/clash_status.dart';
import '../models/clash_connection.dart';

class ClashService {
  static const String _baseUrl = 'ws://192.168.55.212:9999';
  final String? _token;
  bool _isDisposed = false;

  WebSocketChannel? _trafficChannel;
  WebSocketChannel? _memoryChannel;
  WebSocketChannel? _connectionsChannel;
  Timer? _reconnectTimer;

  final _trafficController = StreamController<ClashTraffic>.broadcast();
  final _memoryController = StreamController<ClashMemory>.broadcast();
  final _connectionsController =
      StreamController<List<ClashConnection>>.broadcast();

  Stream<ClashTraffic> get trafficStream => _trafficController.stream;
  Stream<ClashMemory> get memoryStream => _memoryController.stream;
  Stream<List<ClashConnection>> get connectionsStream =>
      _connectionsController.stream;

  ClashService({String? token}) : _token = token;

  void connect() {
    if (_isDisposed) return;
    _connectTraffic();
    _connectMemory();
    _connectConnections();
  }

  String _getUrl(String endpoint) {
    return _token == null
        ? '$_baseUrl/$endpoint'
        : '$_baseUrl/$endpoint?token=$_token';
  }

  Future<void> _connectTraffic() async {
    if (_isDisposed) return;

    try {
      _trafficChannel?.sink.close(status.goingAway);
      _trafficChannel = WebSocketChannel.connect(Uri.parse(_getUrl('traffic')));

      await for (final data in _trafficChannel!.stream) {
        if (_isDisposed) break;
        try {
          final json = jsonDecode(data as String) as Map<String, dynamic>;
          _trafficController.add(ClashTraffic.fromJson(json));
        } catch (e) {
          developer.log('Traffic data parse error: $e', name: 'ClashService');
        }
      }
    } catch (e) {
      developer.log('Traffic WebSocket error: $e', name: 'ClashService');
      if (!_isDisposed) {
        _scheduleReconnect();
      }
    }
  }

  Future<void> _connectMemory() async {
    if (_isDisposed) return;

    try {
      _memoryChannel?.sink.close(status.goingAway);
      _memoryChannel = WebSocketChannel.connect(Uri.parse(_getUrl('memory')));

      await for (final data in _memoryChannel!.stream) {
        if (_isDisposed) break;
        try {
          final json = jsonDecode(data as String) as Map<String, dynamic>;
          _memoryController.add(ClashMemory.fromJson(json));
        } catch (e) {
          developer.log('Memory data parse error: $e', name: 'ClashService');
        }
      }
    } catch (e) {
      developer.log('Memory WebSocket error: $e', name: 'ClashService');
      if (!_isDisposed) {
        _scheduleReconnect();
      }
    }
  }

  Future<void> _connectConnections() async {
    if (_isDisposed) return;

    try {
      _connectionsChannel?.sink.close(status.goingAway);
      _connectionsChannel =
          WebSocketChannel.connect(Uri.parse(_getUrl('connections')));

      await for (final data in _connectionsChannel!.stream) {
        if (_isDisposed) break;
        try {
          final json = jsonDecode(data as String) as Map<String, dynamic>;
          final connectionsList = json['connections'] as List<dynamic>;
          final connections = connectionsList
              .map((conn) =>
                  ClashConnection.fromJson(conn as Map<String, dynamic>))
              .toList()
            ..sort((a, b) =>
                (b.upload + b.download).compareTo(a.upload + a.download));
          _connectionsController.add(connections);
        } catch (e, stack) {
          developer.log(
            'Connections data parse error: $e\nStack: $stack',
            name: 'ClashService',
          );
        }
      }
    } catch (e) {
      developer.log('Connections WebSocket error: $e', name: 'ClashService');
      if (!_isDisposed) {
        _scheduleReconnect();
      }
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_isDisposed) {
        connect();
      }
    });
  }

  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _trafficChannel?.sink.close(status.goingAway);
    _memoryChannel?.sink.close(status.goingAway);
    _connectionsChannel?.sink.close(status.goingAway);
    _trafficController.close();
    _memoryController.close();
    _connectionsController.close();
  }
}
