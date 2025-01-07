import 'package:flutter/material.dart';

class ClockDisplay extends StatelessWidget {
  final DateTime time;

  const ClockDisplay({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w300,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Text(
          time.second.toString().padLeft(2, '0'),
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
