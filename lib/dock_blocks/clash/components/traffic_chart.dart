import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';

class TrafficChart extends StatelessWidget {
  final List<double> uploadHistory;
  final List<double> downloadHistory;

  const TrafficChart({
    super.key,
    required this.uploadHistory,
    required this.downloadHistory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '实时速度',
              style: TextStyle(
                fontFamily: '.SF Pro Text',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? CupertinoColors.systemGrey
                    : CupertinoColors.systemGrey2,
              ),
            ),
            Row(
              children: [
                Container(
                  width: AppMetrics.spacing.xs,
                  height: AppMetrics.spacing.xs,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppMetrics.spacing.tiny),
                Text(
                  '上传',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.systemGrey2,
                  ),
                ),
                SizedBox(width: AppMetrics.spacing.medium),
                Container(
                  width: AppMetrics.spacing.xs,
                  height: AppMetrics.spacing.xs,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemIndigo,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppMetrics.spacing.tiny),
                Text(
                  '下载',
                  style: TextStyle(
                    fontFamily: '.SF Pro Text',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.systemGrey2,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppMetrics.spacing.small),
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
              uploadHistory: uploadHistory,
              downloadHistory: downloadHistory,
              uploadColor: CupertinoColors.systemBlue,
              downloadColor: CupertinoColors.systemIndigo,
              gridColor: AppColors.getBorderColor(isDark),
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
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
