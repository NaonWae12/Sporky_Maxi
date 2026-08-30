import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class FoodHistoryCmp extends StatelessWidget {
  const FoodHistoryCmp({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Image.asset('assets/giff/fail.gif', height: 100),
          Text(
            'Belum Ada Riwayat Makan Anak',
            style: AppTextStyles.heading3SemiBold(),
          ),
          GlobalsCard(
            padding: const EdgeInsets.all(8),
            backgroundColor: AppColors.base4,
            hasShadow: false,
            child: Text(
              'Saat ini riwayat makan anak belum dapat diakses. Kamu tetap bisa membantu orang tua melalui catatan konsultasi, ya!',
              style: AppTextStyles.list1Regular(),
            ),
          ),
        ],
      ),
    );
  }
}
