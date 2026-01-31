import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_category.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../components/dashboard_page_cmp/cmp_chart/z_score_line_chart_cmp.dart';
import '../../../components/expert_components/profile/child_development_cmp.dart';

class PageZScore extends StatelessWidget {
  final String childUuid;
  final String? childName;
  const PageZScore({
    super.key,
    this.childName = 'Kiano',
    required this.childUuid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            Text(
              'Z-Score $childName',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZScoreLineChartCmp(
              showButton: false,
              childUuid: childUuid,
              limit: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CmpTagCategory(
                  text: 'Detail Perkembangan Anak',
                  textStyle:
                      AppTextStyles.heading3SemiBold(AppColors.secondary1),
                  imageAsset: 'assets/svg/ic_ growth.svg'),
            ),
            ChildDevelopmentCmp(
              zScore: '0.18',
              weight: '25',
              height: '120',
            ),
            ChildDevelopmentCmp(
              zScore: '1.18',
              weight: '25',
              height: '120',
            ),
            ChildDevelopmentCmp(
              zScore: '1.18',
              weight: '25',
              height: '120',
            ),
            ChildDevelopmentCmp(
              zScore: '1.18',
              weight: '25',
              height: '120',
            ),
          ],
        ),
      ),
    );
  }
}
