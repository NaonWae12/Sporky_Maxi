import 'package:flutter/material.dart';
import '../../components/globals/text/text_style.dart';
import '../../components/meal_form_cmp/cmp_add_fix_meal_form.dart';
import '../../components/meal_form_cmp/cmp_meal_form.dart';
// import '../../components/meal_form_cmp/cmp_normal_meal_form.dart';

class AddMealCategoryPage extends StatelessWidget {
  const AddMealCategoryPage({
    super.key,
    this.selectedMeal,
    this.selectedCalorieMethod,
    this.mealPlanUuid,
    this.mealPlanName,
    this.mealPlanCarbohydrate,
    this.mealPlanProtein,
    this.mealPlanFat,
    this.mealPlanCalories,
  });

  final DropdownItem? selectedMeal;
  final DropdownItem? selectedCalorieMethod;
  final String? mealPlanUuid;
  final String? mealPlanName;
  final double? mealPlanCarbohydrate;
  final double? mealPlanProtein;
  final double? mealPlanFat;
  final double? mealPlanCalories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                'Tambah Form Makanan',
                style: AppTextStyles.heading1SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CmpAddFixMealForm(
              selectedMeal: selectedMeal,
              selectedCalorieMethod: selectedCalorieMethod,
              mealPlanUuid: mealPlanUuid,
              mealPlanName: mealPlanName,
              mealPlanCarbohydrate: mealPlanCarbohydrate,
              mealPlanProtein: mealPlanProtein,
              mealPlanFat: mealPlanFat,
              mealPlanCalories: mealPlanCalories,
            )
          ],
        ),
      ),
    );
  }
}
