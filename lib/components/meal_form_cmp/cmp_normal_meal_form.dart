import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals/button/globals_button.dart';
import '../globals/card/cmp_tag_attention.dart';
import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';
import 'cmp_add_meal_form.dart';

class CmpNormalMealForm extends StatelessWidget {
  const CmpNormalMealForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CmpTagAttention(
          imageAsset: 'assets/svg/ic_question_mark.svg',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Butuh Bantuan Mengukur Takaran?',
                style: AppTextStyles.list1SemiBold(),
              ),
              Text(
                'Lihat food model kami untuk membandingkan ukuran makanan dalam gram, porsi, atau mangkuk. Agar lebih mudah isi form kalori!',
                style: AppTextStyles.list1Regular(),
              ),
            ],
          ),
        ),
        GlobalsCard(
          hasShadow: false,
          height: 23,
          backgroundColor: AppColors.secondary1,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                height: 16,
                width: 16,
                'assets/svg/bento-box-rounded.svg',
                colorFilter: const ColorFilter.mode(
                  AppColors.base5,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Panduan Ukuran Makanan',
                style: AppTextStyles.list1Bold(AppColors.base5),
              ),
            ],
          ),
        ),
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form makan pagi sudah terbuka')),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/bento-box-rounded.svg'),
                  const SizedBox(width: 8),
                  Text('Makan Pagi', style: AppTextStyles.headList1Regular()),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mode isi manual sudah aktif')),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/bento-box-rounded.svg'),
                  const SizedBox(width: 8),
                  Text('Isi Manual', style: AppTextStyles.headList1Regular()),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        const CmpAddMealForm(),
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
                  content: Text('Lengkapi data makanan sebelum menyimpan'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.base5, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: GlobalsButtonText(
                    text: 'Simpan Kalori Makanan',
                    style: AppTextStyles.headList1Bold(AppColors.base5),
                  ),
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
          SizedBox(height: 18, width: 18, child: SvgPicture.asset(iconPath)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.list3Regular()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: AppTextStyles.heading3SemiBold()),
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
