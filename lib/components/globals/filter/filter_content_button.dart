import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

import '../dialog/modal_bottom_sheet.dart';

class FilterContentButton extends StatelessWidget {
  final String title;
  final List<String> categories;
  final Function(List<String>) onFilterApplied;

  const FilterContentButton({
    super.key,
    required this.title,
    required this.categories,
    required this.onFilterApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () async {
          final selected = await showFilterBottomSheet(
            context,
            title: title,
            categories: categories,
          );
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
          child: const Icon(
            Icons.tune,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
