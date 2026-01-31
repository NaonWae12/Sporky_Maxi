import 'package:flutter/material.dart';

import '../globals/card/meal_card.dart';

class MealPlanRecommendation extends StatelessWidget {
  const MealPlanRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            MealCard(
              imagePath: 'assets/temp_img/meal1.png',
              category: 'Sandwich, jeruk manis',
              title: 'Mix Platter-1',
              description: 'Sandwich, jeruk ma...',
              calories: 145,
              categoryType: 'Makan Pagi',
              onTap: () {},
            ),
            MealCard(
              isSporkyPlus: true,
              imagePath: 'assets/temp_img/meal1.png',
              category: 'Sandwich, jeruk manis',
              title: 'Mix Platter-1',
              description: 'Sandwich, jeruk ma...',
              calories: 145,
              categoryType: 'Makan Siang',
              onTap: () {},
            ),
            MealCard(
              imagePath: 'assets/temp_img/meal1.png',
              category: 'Sandwich, jeruk manis',
              title: 'Mix Platter-1',
              description: 'Sandwich, jeruk ma...',
              calories: 145,
              categoryType: 'Cemilan Pagi',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
