import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/detail_meal_plan_cmp/bottom_content_meal.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/detail_meal_plan_cmp/middle_content_meal.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/detail_meal_plan_cmp/top_content_meal.dart';

import '../../models/components/meal_plan_cmp_mdl/nutrien_card_data.dart';

class DetailMealPlan extends StatelessWidget {
  const DetailMealPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width,
          automaticallyImplyLeading: false,
          leading: Row(
            children: [
              const SizedBox(width: 5),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text('Detail Meal Plan', style: AppTextStyles.heading2SemiBold())
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopContentMeal(
              title: 'Brocoli Pasta',
              likes: 123,
              categories: 'Makan siang',
              value: '125',
              nutrientCards: [
                NutrientCardData(
                  label: 'Karbohidrat',
                  labelCategory: 'gr',
                  labelValue: '28',
                  imageAsset: 'assets/svg/ic_nutrition.svg',
                ),
                NutrientCardData(
                  label: 'Lemak',
                  labelCategory: 'gr',
                  labelValue: '9',
                  imageAsset: 'assets/svg/ic_fat.svg',
                ),
                NutrientCardData(
                  label: 'Protein',
                  labelCategory: 'gr',
                  labelValue: '10',
                  imageAsset: 'assets/svg/ic_proteins.svg',
                ),
                NutrientCardData(
                  label: 'Total Kalori',
                  labelCategory: 'kcal',
                  labelValue: '250',
                  imageAsset: 'assets/svg/ic_fire.svg',
                ),
              ],
            ),
            const MiddleContentMeal(),
            const BottomContentMeal()
          ],
        ),
      ),
    );
  }
}
