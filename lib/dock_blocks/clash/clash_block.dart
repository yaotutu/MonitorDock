import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/block/base_block.dart';
import '../../core/components/common_webview.dart';
import '../../core/theme/app_theme.dart';
import 'components/speed_card.dart';
import 'components/traffic_chart.dart';
import 'models/clash_traffic.dart';
import 'utils/format_utils.dart';

class ClashBlock extends StatefulWidget {
  final String baseUrl;
  final String token;

  const ClashBlock({
    super.key,
    required this.baseUrl,
    required this.token,
  });

  @override
  State<ClashBlock> createState() => _ClashBlockState();
}

class _ClashBlockState extends State<ClashBlock> {
  WebSocketChannel? _trafficChannel;
  Timer? _reconnectTimer;
  ClashTraffic? _traffic;
  bool _isLoading = true;

  // 用于绘制图表的历史数据
  final List<double> _uploadHistory = [];
  final List<double> _downloadHistory = [];
  static const int _maxHistoryLength = 60;

  @override
  void initState() {
    super.initState();
    // 初始化历史数据
    for (var i = 0; i < _maxHistoryLength; i++) {
      _uploadHistory.add(0);
      _downloadHistory.add(0);
    }
    _connectWebSocket();
  }

  String _buildWsUrl(String path) {
    final baseUrl = widget.baseUrl
        .replaceAll(RegExp(r'/+$'), '')
        .replaceAll(RegExp(r'^http://'), 'ws://');
    return '$baseUrl/$path${widget.token.isNotEmpty ? "?token=${widget.token}" : ""}';
  }

  void _connectWebSocket() {
    try {
      final wsUri = Uri.parse(_buildWsUrl('traffic'));
      _trafficChannel = WebSocketChannel.connect(wsUri);
      _trafficChannel?.stream.listen(
        (message) {
          final data = jsonDecode(message);
          _handleTrafficData(data);
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
          _scheduleReconnect();
        },
      );
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), _connectWebSocket);
  }

  void _handleTrafficData(Map<String, dynamic> data) {
    setState(() {
      _isLoading = false;
      _traffic = ClashTraffic.fromJson(data);

      // 更新历史数据
      if (_uploadHistory.length >= _maxHistoryLength) {
        _uploadHistory.removeAt(0);
        _downloadHistory.removeAt(0);
      }
      _uploadHistory.add(_traffic!.upload / 1024 / 1024); // 转换为 MB/s
      _downloadHistory.add(_traffic!.download / 1024 / 1024); // 转换为 MB/s
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const BaseBlock(
        width: AppMetrics.defaultBlockWidth,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final webUiUrl = "http://192.168.55.212:9999/ui/";

    return BaseBlock(
      width: AppMetrics.defaultBlockWidth,
      expandedContent: CommonWebView(
        url: webUiUrl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Icon(
                CupertinoIcons.speedometer,
                size: AppMetrics.iconSizes.medium,
                color: CupertinoColors.systemBlue,
              ),
              SizedBox(width: AppMetrics.spacing.small),
              Text(
                '网络流量',
                style: TextStyle(
                  fontFamily: '.SF Pro Display',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: isDark ? CupertinoColors.white : CupertinoColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.spacing.large),
          // 速度显示
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SpeedCard(
                icon: CupertinoIcons.arrow_up,
                label: '上传',
                speed: formatSpeed(_traffic!.upload),
                total: formatBytes(_traffic!.uploadTotal),
                color: CupertinoColors.systemBlue,
              ),
              SpeedCard(
                icon: CupertinoIcons.arrow_down,
                label: '下载',
                speed: formatSpeed(_traffic!.download),
                total: formatBytes(_traffic!.downloadTotal),
                color: CupertinoColors.systemIndigo,
              ),
            ],
          ),
          SizedBox(height: AppMetrics.spacing.large),
          // 流量图表
          TrafficChart(
            uploadHistory: _uploadHistory,
            downloadHistory: _downloadHistory,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _trafficChannel?.sink.close();
    _reconnectTimer?.cancel();
    super.dispose();
  }
}
