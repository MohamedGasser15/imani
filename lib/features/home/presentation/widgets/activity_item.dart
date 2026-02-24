import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final int current;
  final int total;

  const ActivityItem({
    super.key,
    required this.title,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
     final isLight = Theme.of(context).brightness == Brightness.light;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isLight ? AppColors.lightTeal : AppColors.darkSurface.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isLight ? AppColors.primary : AppColors.secondary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$current / $total',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isLight ? AppColors.primary : AppColors.secondary,
            ),
          ),
        ),
      ],
    ),
  );
}
}