import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/profile_cmp/short_banner_profile.dart';

import '../../../components/dashboard_page_cmp/child_eating_history_cmp/page_history_list.dart';
import '../../../components/dashboard_page_cmp/cmp_chart/child_nutrition_chart.dart';
import '../../../components/globals/text/text_style.dart';

class MainPageEatingHistory extends StatelessWidget {
  const MainPageEatingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text(
              'Riwayat Makan Anak',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          const ShortBannerProfile(
            childName: 'Kiara Alicia',
            ageYear: 1,
            ageMonth: 8,
            status: 'Normal',
          ),
          ChildNutritionChart(),
          const Expanded(child: PageHistoryList())
        ],
      ),
    );
  }
}
