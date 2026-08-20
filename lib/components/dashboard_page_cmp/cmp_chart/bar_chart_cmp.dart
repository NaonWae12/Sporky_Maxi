import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../views/dashboard_page/child_eating_history/main_page_eating_history.dart';
import '../../globals/chart/z_score_bar_chart.dart';
import 'food_waste_alert_cmp.dart';

class BarChartCmp extends StatelessWidget {
  final double heightButton;
  final String? childUuid;
  const BarChartCmp({
    super.key,
    this.heightButton = 22,
    this.childUuid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalsCard(
            width: 90,
            hasShadow: false,
            padding: EdgeInsets.only(left: 8),
            border: Border.all(color: AppColors.primary2),
            child: Row(
              children: [
                Text(
                  'Mingguan',
                  style: AppTextStyles.list1Bold(AppColors.primary1),
                ),
                Icon(Icons.keyboard_arrow_down, color: AppColors.primary1)
              ],
            )),
        SizedBox(
          height: 200,
          child: ZScoreBarChart(
            data: [
              ZScoreBarChartData(8, 60),
              ZScoreBarChartData(9, 90),
              ZScoreBarChartData(10, 100),
              ZScoreBarChartData(11, 75),
              ZScoreBarChartData(12, 45),
              ZScoreBarChartData(13, 70),
              ZScoreBarChartData(14, 30),
            ],
            minY: 0,
            maxY: 100,
            intervalY: 20,
            barColor: AppColors.primary1,
            trackColor: AppColors.primary2.withAlpha(70),
            barWidth: 0.3,
            borderRadius: 8,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 9,
              width: 9,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary1,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary1,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ]),
            ),
            const SizedBox(width: 5),
            Text(
              'Minggu ke-2 Juni',
              style: AppTextStyles.list1Regular(),
            )
          ],
        ),
        const SizedBox(height: 8),
        FoodWasteAlertCmp(childUuid: childUuid),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: GlobalsButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPageEatingHistory()));
              },
              height: heightButton,
              width: MediaQuery.of(context).size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Riwayat Makan Anak',
                      style: AppTextStyles.list1Bold(AppColors.base5)),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
