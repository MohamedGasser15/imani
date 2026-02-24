import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';

class SmallCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const SmallCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),

            // 👇 الفرق هنا
            boxShadow: isLight
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],

            border: isLight
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isLight
                    ? AppColors.secondary
                    : Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isLight
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}