import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../../core/block/base_block.dart';
import '../../core/theme/app_theme.dart';
import 'models/clash_traffic.dart';

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
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseBlock(
      width: AppMetrics.defaultBlockWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Icon(
                Icons.speed_rounded,
                size: AppMetrics.iconSizes.medium,
                color: AppColors.primary,
              ),
              SizedBox(width: AppMetrics.spacing.small),
              Text(
                '网络流量',
                style: AppTypography.title(isDark: isDark),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.spacing.large),
          // 速度显示
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpeedCard(
                context,
                icon: Icons.upload_rounded,
                label: '上传',
                speed: _formatSpeed(_traffic!.upload),
                total: _formatBytes(_traffic!.uploadTotal),
                color: AppColors.primary,
              ),
              _buildSpeedCard(
                context,
                icon: Icons.download_rounded,
                label: '下载',
                speed: _formatSpeed(_traffic!.download),
                total: _formatBytes(_traffic!.downloadTotal),
                color: AppColors.secondary,
              ),
            ],
          ),
          SizedBox(height: AppMetrics.spacing.large),
          // 图表标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '实时速度',
                style: AppTypography.label(isDark: isDark),
              ),
              Row(
                children: [
                  Container(
                    width: AppMetrics.spacing.xs,
                    height: AppMetrics.spacing.xs,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppMetrics.spacing.tiny),
                  Text(
                    '上传',
                    style: AppTypography.label(isDark: isDark),
                  ),
                  SizedBox(width: AppMetrics.spacing.medium),
                  Container(
                    width: AppMetrics.spacing.xs,
                    height: AppMetrics.spacing.xs,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppMetrics.spacing.tiny),
                  Text(
                    '下载',
                    style: AppTypography.label(isDark: isDark),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppMetrics.spacing.small),
          // 图表
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppMetrics.containerRadius),
              color: AppColors.getContainerColor(isDark),
              border: Border.all(
                color: AppColors.getBorderColor(isDark),
                width: AppMetrics.borderWidth,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              size: const Size.fromHeight(120),
              painter: _TrafficChartPainter(
                uploadHistory: _uploadHistory,
                downloadHistory: _downloadHistory,
                uploadColor: AppColors.primary,
                downloadColor: AppColors.secondary,
                gridColor: AppColors.getBorderColor(isDark),
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String speed,
    required String total,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.containerPaddingH,
        vertical: AppMetrics.containerPaddingV,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppMetrics.containerRadius),
        color: AppColors.getContainerColor(isDark),
        border: Border.all(
          color: AppColors.getBorderColor(isDark),
          width: AppMetrics.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: AppMetrics.iconSizes.small,
                color: color,
              ),
              SizedBox(width: AppMetrics.spacing.tiny),
              Text(
                label,
                style: AppTypography.label(isDark: isDark),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.spacing.tiny),
          Text(
            speed,
            style: AppTypography.subtitle(isDark: isDark).copyWith(
              color: color,
            ),
          ),
          Text(
            '总计: $total',
            style: AppTypography.small(isDark: isDark),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatSpeed(int bytesPerSecond) {
    if (bytesPerSecond < 1024) return '$bytesPerSecond B/s';
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    }
    if (bytesPerSecond < 1024 * 1024 * 1024) {
      return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB/s';
  }

  @override
  void dispose() {
    _trafficChannel?.sink.close();
    _reconnectTimer?.cancel();
    super.dispose();
  }
}

class _TrafficChartPainter extends CustomPainter {
  final List<double> uploadHistory;
  final List<double> downloadHistory;
  final Color uploadColor;
  final Color downloadColor;
  final Color gridColor;
  final bool isDark;

  _TrafficChartPainter({
    required this.uploadHistory,
    required this.downloadHistory,
    required this.uploadColor,
    required this.downloadColor,
    required this.gridColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制网格
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // 横向网格线
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // 纵向网格线
    for (var i = 0; i < 7; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    final uploadPaint = Paint()
      ..color = uploadColor.withOpacity(isDark ? 0.25 : 0.15)
      ..style = PaintingStyle.fill;

    final downloadPaint = Paint()
      ..color = downloadColor.withOpacity(isDark ? 0.25 : 0.15)
      ..style = PaintingStyle.fill;

    final uploadLinePaint = Paint()
      ..color = uploadColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final downloadLinePaint = Paint()
      ..color = downloadColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final maxValue = [
      ...uploadHistory,
      ...downloadHistory,
    ].reduce((a, b) => a > b ? a : b);

    void drawHistory(
      List<double> history,
      Paint fillPaint,
      Paint linePaint,
    ) {
      if (history.isEmpty) return;

      final path = Path();
      final linePath = Path();
      final width = size.width / (history.length - 1);

      path.moveTo(0, size.height);

      for (var i = 0; i < history.length; i++) {
        final x = i * width;
        final y = size.height -
            (history[i] / (maxValue > 0 ? maxValue : 1) * size.height);

        if (i == 0) {
          path.moveTo(x, y);
          linePath.moveTo(x, y);
        } else {
          path.lineTo(x, y);
          linePath.lineTo(x, y);
        }
      }

      path.lineTo(size.width, size.height);
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(linePath, linePaint);
    }

    drawHistory(downloadHistory, downloadPaint, downloadLinePaint);
    drawHistory(uploadHistory, uploadPaint, uploadLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
