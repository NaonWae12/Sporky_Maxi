import 'dart:math';

import 'package:flutter/material.dart';

import '../colors/colors.dart';
import '../text/text_style.dart';

class CardLableMealPlan extends StatelessWidget {
  final String categoryType;

  const CardLableMealPlan({
    super.key,
    required this.categoryType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 76,
      decoration: BoxDecoration(
        color: AppColors.base5,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getBorderColor(categoryType),
        ),
      ),
      child: Center(
        child: Text(
          categoryType,
          style: AppTextStyles.list3SemiBold(_getBorderColor(categoryType)),
        ),
      ),
    );
  }
}

Color _getBorderColor(String category) {
  switch (category.toLowerCase()) {
    case "makan pagi":
      return AppColors.primary1;
    case "makan siang":
      return AppColors.warn1;
    case "makan malam":
      return AppColors.secondary1;
    case "cemilan pagi":
      return AppColors.info1;
    case "cemilan sore":
      return AppColors.info1;
    default:
      // Pilih 1 dari 4 warna alternatif secara random
      final random = Random();
      final fallbackColors = [
        AppColors.primary2, // kuning terang
        AppColors.secondary2, // biru sangat muda
        AppColors.warn2, // merah peach
        AppColors.success1, // hijau terang
      ];
      return fallbackColors[random.nextInt(fallbackColors.length)];
  }
}
