import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../globals/colors/colors.dart';
import 'all_insight_cmp.dart';

class InsightConsultationCmp extends StatefulWidget {
  const InsightConsultationCmp({super.key});

  @override
  State<InsightConsultationCmp> createState() => _InsightConsultationCmpState();
}

class _InsightConsultationCmpState extends State<InsightConsultationCmp> {
  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      hasShadow: false,
      backgroundColor: AppColors.base4,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          GlobalsCard(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(10),
            hasShadow: false,
            backgroundColor: AppColors.base5,
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/ic_ growth.svg'),
                const SizedBox(width: 8),
                Text(
                  'Insight Konsultasi',
                  style: AppTextStyles.heading3SemiBold(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 155,
            child: FullWidthTabBar(
              tabs: const ['Semua', 'Mingguan', 'Bulanan'],
              tabViews: const [
                AllInsightCmp(),
                AllInsightCmp(period: 'week'),
                AllInsightCmp(period: 'month'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
