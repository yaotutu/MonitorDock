import 'package:flutter/material.dart';

class ClockDisplay extends StatelessWidget {
  final DateTime time;

  const ClockDisplay({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                style: textTheme.displayLarge?.copyWith(
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -2,
                  color: colorScheme.onSurface,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time.second.toString().padLeft(2, '0'),
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_getWeekDay(time.weekday)}, ${_getMonth(time.month)} ${time.day}',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekDay(int weekday) {
    switch (weekday) {
      case 1:
        return '星期一';
      case 2:
        return '星期二';
      case 3:
        return '星期三';
      case 4:
        return '星期四';
      case 5:
        return '星期五';
      case 6:
        return '星期六';
      case 7:
        return '星期日';
      default:
        return '';
    }
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return '1月';
      case 2:
        return '2月';
      case 3:
        return '3月';
      case 4:
        return '4月';
      case 5:
        return '5月';
      case 6:
        return '6月';
      case 7:
        return '7月';
      case 8:
        return '8月';
      case 9:
        return '9月';
      case 10:
        return '10月';
      case 11:
        return '11月';
      case 12:
        return '12月';
      default:
        return '';
    }
  }
}
