import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';

import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/progres/progres_slider.dart';
import '../globals/text/text_style.dart';
import '../meal_form_cmp/cmp_add_meal_form.dart';

class AddFormWasteCmp extends StatelessWidget {
  const AddFormWasteCmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/bento-box-rounded.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.primary1, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text('Makan Pagi', style: AppTextStyles.headList1Regular()),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                ),
              )
            ],
          ),
        ),
        const CmpAddMealForm(
          normalFill: false,
        ),
        const ProgressSlider(
          label: 'sisa menu',
          percentage: 0.20,
        ),
        const CmpAddMealForm(
          normalFill: false,
        ),
        const ProgressSlider(
          label: 'sisa menu',
          percentage: 0.40,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildNutritionCard(
                'assets/svg/ic_nutrition.svg', 'Karbohidrat', '100', 'gr'),
            _buildNutritionCard('assets/svg/ic_fat.svg', 'Lemak', '100', 'gr'),
            _buildNutritionCard(
                'assets/svg/ic_proteins.svg', 'Protein', '100', 'gr'),
            _buildNutritionCard(
                'assets/svg/ic_fire.svg', 'Total Kalori', '100', 'kcal'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const GlobalsCard(
                margin: EdgeInsets.only(left: 16),
                hasShadow: false,
                backgroundColor: AppColors.primary1,
                height: 44,
                width: 56,
                child: Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: AppColors.base5,
                )),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GlobalsButton(
                  elevation: 0,
                  height: 44,
                  width: MediaQuery.of(context).size.width / 1.5,
                  color: AppColors.secondary1,
                  onPressed: () {},
                  text: 'Simpan Data Sisa Makanan',
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

Widget _buildNutritionCard(
    String iconPath, String title, String value, String unit) {
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
          Text(
            title,
            style: AppTextStyles.list1Regular(),
          ),
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
                    Text(
                      unit,
                      style: AppTextStyles.heading3SemiBold(),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
