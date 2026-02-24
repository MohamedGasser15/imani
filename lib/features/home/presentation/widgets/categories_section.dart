import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/l10n/app_localizations.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isLight = Theme.of(context).brightness == Brightness.light;

final List<CategoryItem> categories = [
  // الصف الأول
  CategoryItem(icon: Icons.menu_book, label: t.mushaf, color: AppColors.primary),
  CategoryItem(icon: Icons.book, label: t.azkar, color: AppColors.secondary),
  CategoryItem(icon: Icons.assistant_navigation, label: t.tasbih, color: AppColors.primary),
  CategoryItem(icon: Icons.explore, label: t.qibla, color: AppColors.secondary),
  
  // الصف الثاني
  CategoryItem(icon: Icons.favorite, label: t.dua, color: AppColors.primary),
  CategoryItem(icon: Icons.calculate, label: t.zakat, color: AppColors.secondary),
  CategoryItem(icon: Icons.calendar_month, label: t.ramadan_calendar, color: AppColors.primary),
  CategoryItem(icon: Icons.calendar_today, label: t.calendar, color: AppColors.secondary),
];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان المحسن
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isLight ? AppColors.primary : AppColors.secondary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: isLight ? AppColors.primary : AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    t.categories,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isLight ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // الأزرار في grid - ضبط childAspectRatio
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.87, // تم التعديل ليتناسب مع المحتوى
                children: categories.map((cat) => _buildCategoryItem(context, cat)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildCategoryItem(BuildContext context, CategoryItem cat) {
  final isLight = Theme.of(context).brightness == Brightness.light;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cat.label} tapped'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
  color: Theme.of(context).colorScheme.surface,
  borderRadius: BorderRadius.circular(20),
  boxShadow: isLight
      ? [
          BoxShadow(
            color: cat.color.withOpacity(0.10),
            blurRadius: 8,
          ),
        ]
      : [],
  border: isLight
      ? null
      : Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cat.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(cat.icon, color: cat.color, size: 24),
            ),
            const SizedBox(height: 6),
            // هنا التعديل: FittedBox لضبط النص الطويل
            Container(
              width: double.infinity, // يأخذ كامل عرض العمود
              child: FittedBox(
                fit: BoxFit.scaleDown, // يصغر النص إذا لزم الأمر
                child: Text(
                  cat.label,
                  style: TextStyle(
                    fontSize: 12, // الحجم الأساسي
                    fontWeight: FontWeight.w600,
                    color: isLight ? AppColors.primary : Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}}

class CategoryItem {
  final IconData icon;
  final String label;
  final Color color;

  CategoryItem({required this.icon, required this.label, required this.color});
}