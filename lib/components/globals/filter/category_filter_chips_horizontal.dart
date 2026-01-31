import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class CategoryFilterChipsHorizontal extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final EdgeInsetsGeometry padding;

  const CategoryFilterChipsHorizontal({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: List.generate(categories.length, (index) {
          final bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary1 : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.secondary1 : AppColors.base2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  categories[index],
                  style: isSelected
                      ? AppTextStyles.list1Bold(AppColors.base5)
                      : AppTextStyles.list1Regular(AppColors.base2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
