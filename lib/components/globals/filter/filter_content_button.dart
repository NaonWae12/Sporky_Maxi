import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../dialog/modal_bottom_sheet.dart';

class FilterContentButton extends StatelessWidget {
  final String title;
  final List<String> categories;
  final List<Map<String, dynamic>>? structuredCategories;
  final List<String> initialSelected;
  final String? buttonText;
  final Function(List<String>) onFilterApplied;

  const FilterContentButton({
    super.key,
    required this.title,
    required this.categories,
    required this.onFilterApplied,
    this.structuredCategories,
    this.initialSelected = const [],
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () async {
          final List<String>? selected;
          if (structuredCategories != null) {
            selected = await showIngredientFilterBottomSheet(
              context,
              title: title,
              structuredCategories: structuredCategories!,
              initialSelected: initialSelected,
              buttonText: buttonText ?? 'Tampilkan Meal Plan',
            );
          } else {
            selected = await showFilterBottomSheet(
              context,
              title: title,
              categories: categories,
              buttonText: buttonText ?? 'Tampilkan Meal Plan',
            );
          }
          if (selected != null) {
            onFilterApplied(selected);
          }
        },
        child: Container(
          width: 35,
          height: 25,
          decoration: const BoxDecoration(
            color: AppColors.secondary2,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: const Icon(Icons.tune, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

/// Tombol urutkan untuk daftar artikel/video. Toggle antara "Terbaru" (default)
/// dan "Terpopuler" (sort by total likes dari backend).
class SortContentButton extends StatelessWidget {
  final bool sortByLikes;
  final ValueChanged<bool> onChanged;

  const SortContentButton({
    super.key,
    required this.sortByLikes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = sortByLikes ? AppColors.secondary2 : AppColors.base4;
    return GestureDetector(
      onTap: () => onChanged(!sortByLikes),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              sortByLikes ? Icons.favorite : Icons.schedule,
              size: 15,
              color: sortByLikes ? AppColors.base5 : AppColors.base1,
            ),
            const SizedBox(width: 5),
            Text(
              sortByLikes ? 'Terpopuler' : 'Terbaru',
              style: AppTextStyles.list1Bold(
                sortByLikes ? AppColors.base5 : AppColors.base1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
