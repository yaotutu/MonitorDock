import 'package:flutter/cupertino.dart';

class ClockDisplay extends StatelessWidget {
  final DateTime time;

  const ClockDisplay({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontFamily: '.SF Pro Display',
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time.second.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: '.SF Pro Display',
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: isDark
                      ? CupertinoColors.systemGrey
                      : CupertinoColors.systemGrey2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_weekdays[time.weekday]}, ${time.month}月 ${time.day}日',
            style: TextStyle(
              fontFamily: '.SF Pro Text',
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.systemGrey2,
            ),
          ),
        ],
      ),
    );
  }

  static const _weekdays = {
    1: '星期一',
    2: '星期二',
    3: '星期三',
    4: '星期四',
    5: '星期五',
    6: '星期六',
    7: '星期日',
  };
}
