import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SpeedCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String speed;
  final String total;
  final Color color;

  const SpeedCard({
    super.key,
    required this.icon,
    required this.label,
    required this.speed,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
