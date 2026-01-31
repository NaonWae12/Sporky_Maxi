import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/meal_plan_page/detail_meal_plan.dart';
import 'package:sporky_maxi/views/meal_plan_page/meal_plan_page.dart';

import '../globals/card/meal_card.dart';

class CmpTopMealPlan extends StatefulWidget {
  const CmpTopMealPlan({super.key});

  @override
  State<CmpTopMealPlan> createState() => _CmpTopMealPlanState();
}

class _CmpTopMealPlanState extends State<CmpTopMealPlan> {
  @override
  Widget build(BuildContext context) {
    final List<MealCard> meal = [
      MealCard(
        imagePath: 'assets/temp_img/meal1.png',
        category: 'Sandwich, jeruk manis',
        title: 'Mix Platter-1',
        description: 'Sandwich, jeruk ma...',
        calories: 145,
        categoryType: 'Makan Pagi',
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailMealPlan(),
              ));
        },
      ),
      MealCard(
        imagePath: 'assets/temp_img/meal1.png',
        category: 'Sandwich, jeruk manis',
        title: 'Mix Platter-2',
        description: 'Sandwich, jeruk ma...',
        calories: 155,
        categoryType: 'Makan Pagi',
        onTap: () {
          debugPrint('Meal 2 tapped');
        },
      ),
      MealCard(
        imagePath: 'assets/temp_img/meal1.png',
        category: 'Sandwich, jeruk manis',
        title: 'Mix Platter-3',
        description: 'Sandwich, jeruk ma...',
        calories: 165,
        categoryType: 'Makan Pagi',
        onTap: () {
          debugPrint('Meal 3 tapped');
        },
      ),
      MealCard(
        imagePath: 'assets/temp_img/meal1.png',
        category: 'Sandwich, jeruk manis',
        title: 'Mix Platter-4',
        description: 'Sandwich, jeruk ma...',
        calories: 175,
        categoryType: 'Makan Pagi',
        onTap: () {
          debugPrint('Meal 4 tapped');
        },
      ),
      MealCard(
        imagePath: 'assets/temp_img/meal1.png',
        category: 'Sandwich, jeruk manis',
        title: 'Mix Platter-5',
        description: 'Sandwich, jeruk ma...',
        calories: 185,
        categoryType: 'Makan Pagi',
        onTap: () {
          debugPrint('Meal 5 tapped');
        },
      ),
    ];
    final int totalMealPlan = meal.length;

    List<Widget> displayedMealPlan =
        totalMealPlan > 3 ? meal.take(4).toList() : meal;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayedMealPlan,
          if (totalMealPlan > 3)
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MealPlanPage()),
                  );
                },
                child: const Text('Lihat Semua'),
              ),
            ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
