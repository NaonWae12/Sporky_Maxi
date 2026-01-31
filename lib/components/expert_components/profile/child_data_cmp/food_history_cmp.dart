import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../../core/data_dummy/food_history_data.dart';
import '../../../dashboard_page_cmp/child_eating_history_cmp/history_list_cmp.dart';

class FoodHistoryCmp extends StatelessWidget {
  const FoodHistoryCmp({super.key});

  @override
  Widget build(BuildContext context) {
    final data = foodHistoryData;

    final bool hasData = data.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (!hasData) ...[
            const SizedBox(height: 15),
            Image.asset(
              'assets/giff/fail.gif',
              height: 100,
            ),
            Text(
              'Belum Ada Riwayat Makan Anak',
              style: AppTextStyles.heading3SemiBold(),
            ),
            GlobalsCard(
              padding: const EdgeInsets.all(8),
              backgroundColor: AppColors.base4,
              hasShadow: false,
              child: Text(
                'Saat ini belum tersedia data riwayat makan karena anak masih dalam langganan gratis. Kamu tetap bisa bantu beri arahan awal untuk orang tua, ya!',
                style: AppTextStyles.list1Regular(),
              ),
            ),
          ] else ...[
            for (final item in data)
              HistoryListCmp(
                historyDay: item['historyDay'],
                mealTime: item['mealTime'],
                hour: item['hour'] ?? 0.0,
                carbohydrate: item['carbohydrate'] ?? 0,
                proteins: item['proteins'] ?? 0,
                fat: item['fat'] ?? 0,
                totalcalories: item['totalcalories'] ?? 0,
                itemName: item['itemName'] ?? '-',
                imageAsset1: item['imageAsset1'],
                imageAsset2: item['imageAsset2'],
              ),
          ],
        ],
      ),
    );
  }
}
