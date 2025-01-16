import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/block/base_block.dart';
import 'models/clash_status.dart';
import 'models/clash_connection.dart';
import 'services/clash_service.dart';

class ClashBlock extends StatefulWidget {
  final String? token;

  const ClashBlock({
    super.key,
    this.token,
  });

  @override
  State<ClashBlock> createState() => _ClashBlockState();
}

class _ClashBlockState extends State<ClashBlock> {
  late final ClashService _service;
  StreamSubscription? _trafficSubscription;
  StreamSubscription? _memorySubscription;
  StreamSubscription? _connectionsSubscription;
  ClashTraffic? _traffic;
  ClashMemory? _memory;
  List<ClashConnection>? _connections;
  bool _isConnected = false;
  String? _error;

  static const primaryColor = Color(0xFF6750A4);
  static const secondaryColor = Color(0xFF625B71);
  static const errorColor = Color(0xFFB3261E);
  static const surfaceColor = Color(0xFF1C1B1F);

  @override
  void initState() {
    super.initState();
    _service = ClashService(token: widget.token);
    _setupSubscriptions();
    _service.connect();
  }

  void _setupSubscriptions() {
    _trafficSubscription = _service.trafficStream.listen(
      (traffic) {
        if (mounted) {
          setState(() {
            _traffic = traffic;
            _isConnected = true;
            _error = null;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isConnected = false;
            _error = '连接失败: $error';
          });
        }
      },
    );

    _memorySubscription = _service.memoryStream.listen(
      (memory) {
        if (mounted) {
          setState(() {
            _memory = memory;
            _isConnected = true;
            _error = null;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isConnected = false;
            _error = '连接失败: $error';
          });
        }
      },
    );

    _connectionsSubscription = _service.connectionsStream.listen(
      (connections) {
        if (mounted) {
          setState(() {
            _connections = connections;
            _isConnected = true;
            _error = null;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isConnected = false;
            _error = '连接失败: $error';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _trafficSubscription?.cancel();
    _memorySubscription?.cancel();
    _connectionsSubscription?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return BaseBlock(
      contentFit: ContentFitMode.scroll,
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _error!,
                style: TextStyle(
                  color: errorColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else if (!_isConnected)
            const CircularProgressIndicator.adaptive()
          else ...[
            if (_traffic != null) _buildTraffic(),
            if (_connections != null && _connections!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildConnections(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(
          Icons.router_outlined,
          color: primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          'Clash',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: MediaQuery.platformBrightnessOf(context) == Brightness.dark
                ? Colors.white
                : surfaceColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTraffic() {
    final traffic = _traffic!;
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.upload_outlined,
            size: 16,
            color: primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            traffic.upSpeed,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.download_outlined,
            size: 16,
            color: secondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            traffic.downSpeed,
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnections() {
    final connections = _connections!.take(5).toList();
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '活跃连接',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...connections.map((conn) => _buildConnectionItem(conn)),
      ],
    );
  }

  Widget _buildConnectionItem(ClashConnection connection) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final textColor = isDark ? Colors.white : surfaceColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connection.host,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      connection.chainString,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                connection.totalTraffic,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.upload_outlined,
                size: 14,
                color: textColor.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                connection.uploadSpeed,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.download_outlined,
                size: 14,
                color: textColor.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                connection.downloadSpeed,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isDark ? Colors.white24 : Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${connection.type} | ${connection.rule}',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
