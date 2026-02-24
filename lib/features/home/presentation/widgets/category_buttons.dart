import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/l10n/app_localizations.dart';

class CategoryButtons extends StatelessWidget {
  const CategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final List<CategoryItem> categories = [
      CategoryItem(icon: Icons.assistant_navigation, label: t.tasbih, color: AppColors.primary, route: 'tasbih'),
      CategoryItem(icon: Icons.book, label: t.azkar, color: AppColors.secondary, route: 'azkar'),
      CategoryItem(icon: Icons.favorite, label: t.dua, color: AppColors.primary, route: 'dua'),
      CategoryItem(icon: Icons.menu_book, label: t.quran, color: AppColors.secondary, route: 'quran'),
      CategoryItem(icon: Icons.explore, label: t.qibla, color: AppColors.primary, route: 'qibla'),
      CategoryItem(icon: Icons.mosque, label: t.mosques, color: AppColors.secondary, route: 'mosques'),
      CategoryItem(icon: Icons.event, label: t.events, color: AppColors.primary, route: 'events'),
      CategoryItem(icon: Icons.calendar_today, label: t.calendar, color: AppColors.secondary, route: 'calendar'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
        children: categories.map((cat) => _buildCategoryItem(context, cat)).toList(),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem cat) {
    return GestureDetector(
      onTap: () {
        // مؤقتاً SnackBar، يمكن استبداله بالملاحة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${cat.label} tapped')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat.icon, color: cat.color, size: 28),
            const SizedBox(height: 8),
            Text(
              cat.label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route; // يمكن استخدامه للملاحة

  CategoryItem({required this.icon, required this.label, required this.color, required this.route});
}