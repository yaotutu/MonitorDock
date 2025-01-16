import 'package:flutter/material.dart';
import '../../core/block/base_block.dart';
import '../../core/block/block_overflow.dart';
import 'models/server_status.dart';
import 'server_status_service.dart';
import 'status_item.dart';

class ServerStatusBlock extends StatefulWidget {
  const ServerStatusBlock({super.key});

  @override
  State<ServerStatusBlock> createState() => _ServerStatusBlockState();
}

class _ServerStatusBlockState extends State<ServerStatusBlock> {
  final _service = ServerStatusService();
  bool _isLoading = true;
  String? _errorMessage;
  ServerStatus? _serverStatus;

  @override
  void initState() {
    super.initState();
    _fetchServerStatus();
  }

  Future<void> _fetchServerStatus() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final status = await _service.fetchStatus();
      if (!mounted) return;

      setState(() {
        _serverStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = '获取服务器状态失败';
      });
    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
      );
    }

    if (_serverStatus == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatusItem(
            label: '状态',
            value: _serverStatus!.status,
            valueColor: _getStatusColor(_serverStatus!.status),
          ),
          const SizedBox(height: 12),
          StatusItem(
            label: '运行时间',
            value: _serverStatus!.uptime,
          ),
          const SizedBox(height: 12),
          StatusItem(
            label: '内存使用',
            value: _serverStatus!.memory,
          ),
          const SizedBox(height: 12),
          StatusItem(
            label: 'CPU使用',
            value: _serverStatus!.cpu,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status.toLowerCase()) {
      case 'running':
        return colorScheme.primary;
      case 'warning':
        return colorScheme.tertiary;
      case 'error':
        return colorScheme.error;
      default:
        return colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseBlock(
      child: _buildContent(),
    );
  }
}
