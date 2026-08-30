import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals/button/globals_button.dart';
import '../globals/card/cmp_tag_attention.dart';
import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';
import 'cmp_add_meal_form.dart';

class CmpAutoFilledMealForm extends StatelessWidget {
  const CmpAutoFilledMealForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CmpTagAttention(
          imageAsset: 'assets/svg/bento-box-rounded.svg',
          child: Text.rich(
            TextSpan(
              style: AppTextStyles.list1Regular(),
              children: [
                const TextSpan(text: 'Mau isi kalori '),
                TextSpan(text: 'manual', style: AppTextStyles.list1Bold()),
                const TextSpan(text: ', pengisian otomatis melalui menu '),
                TextSpan(text: 'meal plan', style: AppTextStyles.list1Bold()),
                const TextSpan(text: ', atau cukup '),
                TextSpan(text: 'scan QR ', style: AppTextStyles.list1Bold()),
                const TextSpan(text: 'catering Sporky? Semuanya bisa!'),
              ],
            ),
          ),
        ),
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/bento-box-rounded.svg'),
                  const SizedBox(width: 8),
                  Text(
                    'Meal Plan (Auto Filled)',
                    style: AppTextStyles.headList1Regular(),
                  ),
                  SvgPicture.asset(height: 11, width: 11, 'assets/svg/sun.svg'),
                ],
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Meal plan otomatis sudah terbuka'),
                    ),
                  );
                },
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
        const CmpAddMealForm(normalFill: false),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildNutritionCard(
              'assets/svg/ic_nutrition.svg',
              'Karbohidrat',
              '100',
              'gr',
            ),
            _buildNutritionCard('assets/svg/ic_fat.svg', 'Lemak', '100', 'gr'),
            _buildNutritionCard(
              'assets/svg/ic_proteins.svg',
              'Protein',
              '100',
              'gr',
            ),
            _buildNutritionCard(
              'assets/svg/ic_fire.svg',
              'Total Kalori',
              '100',
              'kcal',
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: GlobalsButton(
            color: AppColors.secondary1,
            height: 44,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data meal plan otomatis sudah siap'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.base5, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Simpan Kalori Makanan',
                  style: AppTextStyles.headList1Bold(AppColors.base5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildNutritionCard(
  String iconPath,
  String title,
  String value,
  String unit,
) {
  return SizedBox(
    width: 170,
    child: GlobalsCard(
      width: 170,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(vertical: 5),
      backgroundColor: AppColors.base5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath),
          Text(title, style: AppTextStyles.list1Regular()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.heading3SemiBold(AppColors.base2),
              ),
              GlobalsCard(
                radius: 4,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                hasShadow: false,
                backgroundColor: AppColors.base4,
                child: Row(
                  children: [
                    Text(unit, style: AppTextStyles.heading3SemiBold()),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
