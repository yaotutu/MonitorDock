import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ClockDisplay extends StatelessWidget {
  final DateTime time;

  const ClockDisplay({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            style: AppTheme.displayLarge.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Text(
          time.second.toString().padLeft(2, '0'),
          style: AppTheme.labelLarge.copyWith(
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}',
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }
}
