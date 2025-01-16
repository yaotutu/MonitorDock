import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/block/base_block.dart';
import '../../core/block/block_overflow.dart';
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
    return BaseBlock(
      overflowMode: BlockOverflowMode.clip,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
            )
          else if (!_isConnected)
            const CircularProgressIndicator.adaptive()
          else ...[
            if (_traffic != null) _buildTraffic(),
            if (_memory != null) ...[
              const SizedBox(height: 16),
              _buildMemory(),
            ],
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
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'Clash',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildTraffic() {
    final traffic = _traffic!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _buildStatusItem(
          icon: Icons.upload_outlined,
          label: '上传',
          value: traffic.upSpeed,
          valueColor: colorScheme.primary,
        ),
        const SizedBox(height: 8),
        _buildStatusItem(
          icon: Icons.download_outlined,
          label: '下载',
          value: traffic.downSpeed,
          valueColor: colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildMemory() {
    final memory = _memory!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _buildStatusItem(
          icon: Icons.memory_outlined,
          label: '内存',
          value: memory.usageString,
          valueColor: colorScheme.tertiary,
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: memory.usagePercentage,
            backgroundColor: colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(colorScheme.tertiary),
          ),
        ),
      ],
    );
  }

  Widget _buildConnections() {
    final connections = _connections!.take(5).toList();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '活跃连接',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                ),
          ),
        ),
        const SizedBox(height: 8),
        ...connections.map((conn) => _buildConnectionItem(conn)),
      ],
    );
  }

  Widget _buildConnectionItem(ClashConnection connection) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      connection.chainString,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                connection.totalTraffic,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
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
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                connection.uploadSpeed,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.download_outlined,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                connection.downloadSpeed,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${connection.type} | ${connection.rule}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
