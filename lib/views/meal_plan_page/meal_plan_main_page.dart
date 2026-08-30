import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/cmp_bottom_meal_plan.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/cmp_top_meal_plan.dart';

import '../../components/globals/button/cmp_floating_button.dart';
import '../../components/globals/card/cmp_tag_category.dart';
import '../meal_form/meal_form_main_page.dart';

class MealPlanMainPage extends StatelessWidget {
  const MealPlanMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      floatingActionButton: CmpFloatingActionButton(
        imagePath: 'assets/svg/ic_pie_chart.svg',
        imageColor: AppColors.primary1,
        size: 45,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MealFormMainPage()),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('Meal Plan', style: AppTextStyles.heading2SemiBold()),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                imageAsset: 'assets/svg/bento-box-rounded.svg',
                text: 'Menu Terbaik Hari Ini',
                textAndImageColor: AppColors.warn1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CmpTopMealPlan(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CmpTagCategory(
                imageAsset: 'assets/svg/bento-box-rounded.svg',
                text: 'Pilihan Nutrisi yang Tepat Hari Ini',
                textAndImageColor: AppColors.primary1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CmpBottomMealPlan(),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
