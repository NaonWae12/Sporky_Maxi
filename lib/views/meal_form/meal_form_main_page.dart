import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/views/form_food_waste/page_form_food_waste.dart';
import 'package:sporky_maxi/views/meal_form/add_meal_category_page.dart';

import '../../components/globals/button/globals_button.dart';
import '../../components/globals/button/food_portion_guide_button.dart';
import '../../components/globals/colors/colors.dart';
import '../../components/globals/text/text_style.dart';
import '../../components/meal_form_cmp/cmp_meal_form.dart';

class MealFormMainPage extends StatefulWidget {
  const MealFormMainPage({super.key});

  @override
  State<MealFormMainPage> createState() => _MealFormMainPageState();
}

class _MealFormMainPageState extends State<MealFormMainPage> {
  DropdownItem? selectedMeal;
  DropdownItem? selectedCalorieMethod;

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
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text('Form Makanan', style: AppTextStyles.heading2SemiBold()),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CmpTagAttention(
              imageAsset: 'assets/svg/bento-box-rounded.svg',
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.list1Regular(),
                  children: [
                    const TextSpan(text: 'Mau isi kalori '),
                    TextSpan(
                      text: 'manual, ',
                      style: AppTextStyles.list1SemiBold(),
                    ),
                    const TextSpan(
                      text: 'manual pengisian otomatis melalui menu ',
                    ),
                    TextSpan(
                      text: 'meal plan, ',
                      style: AppTextStyles.list1SemiBold(),
                    ),
                    const TextSpan(text: 'atau cukup '),
                    TextSpan(
                      text: 'scan QR ',
                      style: AppTextStyles.list1SemiBold(),
                    ),
                    const TextSpan(text: 'catering Sporky? Semuanya bisa!'),
                  ],
                ),
              ),
            ),
            // =============== tombol panduan porsi makan ==================
            const FoodPortionGuideButton(),

            CmpMealForm(
              selectedMeal: selectedMeal,
              selectedCalorieMethod: selectedCalorieMethod,
              onMealChanged: (item) {
                setState(() {
                  selectedMeal = item;
                });
              },
              onCalorieMethodChanged: (item) {
                setState(() {
                  selectedCalorieMethod = item;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalsButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealCategoryPage(
                      selectedMeal: selectedMeal,
                      selectedCalorieMethod: selectedCalorieMethod,
                    ),
                  ),
                );
              },
              color: AppColors.secondary1,
              text: 'Hitung Kalori',
            ),

            // =============== Next to Page food waste ===============
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                style: AppTextStyles.list1Regular(),
                children: [
                  TextSpan(text: 'mau masukkan data sisa makanan? '),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageFormFoodWaste(),
                          ),
                        );
                      },
                    text: 'klik disini',
                    style: AppTextStyles.list1SemiBold(AppColors.primary1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
