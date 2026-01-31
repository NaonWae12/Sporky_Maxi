import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/expert_components/profile/child_profile_cmp.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../components/globals/dialog/badge_tooltip.dart';
import 'biodata_in_expert.dart';
import 'food_history_in_expert.dart';
import 'page_z_score.dart';

class PageChildProfileInExpert extends StatelessWidget {
  final String childUuid;
  const PageChildProfileInExpert({
    super.key,
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
              'Profil Anak',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          ChildProfileCmp(
            childName: 'childName',
            badge: TooltipStep.hebat,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageZScore(
                      childUuid: childUuid,
                    ),
                  ));
            },
          ),
          Expanded(
            child: FullWidthTabBar(tabs: const [
              'Biodata',
              'Riwayat Makan',
              'Riwayat Medis',
            ], tabViews: const [
              BiodataInExpert(),
              FoodHistoryInExpert(),
              Center(child: Text('Riwayat Medis')),
            ]),
          )
        ],
      ),
    );
  }
}
