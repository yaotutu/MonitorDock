import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../base/base_block.dart';
import '../base/block_overflow.dart';
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

  @override
  Widget build(BuildContext context) {
    return BaseBlock(
      width: 320,
      title: '服务器状态',
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      overflowMode: BlockOverflowMode.scroll,
      child: _serverStatus == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusItem(
                    label: '状态',
                    value: _serverStatus!.status,
                    valueColor: AppTheme.getStatusColor(_serverStatus!.status),
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
            ),
    );
  }
}
