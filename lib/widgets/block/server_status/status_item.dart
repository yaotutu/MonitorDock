import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const StatusItem({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.titleMedium.copyWith(
              color: valueColor ?? AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
