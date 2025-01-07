import 'package:flutter/material.dart';

class ClockDetailView extends StatelessWidget {
  final DateTime time;

  const ClockDetailView({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'World Time',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildTimeZoneItem('UTC', time.toUtc()),
        const SizedBox(height: 8),
        _buildTimeZoneItem('New York', time.subtract(const Duration(hours: 4))),
        const SizedBox(height: 8),
        _buildTimeZoneItem('London', time.add(const Duration(hours: 1))),
        const SizedBox(height: 8),
        _buildTimeZoneItem('Tokyo', time.add(const Duration(hours: 9))),
      ],
    );
  }

  Widget _buildTimeZoneItem(String zone, DateTime time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(zone),
        Text(
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        ),
      ],
    );
  }
}
