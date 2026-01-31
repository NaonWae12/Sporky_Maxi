import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/views/meal_form/add_meal_category_page.dart';

import '../../components/globals/button/globals_button.dart';
import '../../components/globals/colors/colors.dart';
import '../../components/globals/text/text_style.dart';
import '../../components/meal_form_cmp/cmp_meal_form.dart';

class MealFormMainPage extends StatelessWidget {
  const MealFormMainPage({super.key});

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
                'Form Makanan',
                style: AppTextStyles.heading2SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CmpTagAttention(
            imageAsset: 'assets/svg/bento-box-rounded.svg',
            child: Text.rich(
                TextSpan(style: AppTextStyles.list1Regular(), children: [
              const TextSpan(text: 'Mau isi kalori '),
              TextSpan(text: 'manual, ', style: AppTextStyles.list1SemiBold()),
              const TextSpan(text: 'manualpengisian otomatis melalui menu '),
              TextSpan(
                  text: 'meal plan, ', style: AppTextStyles.list1SemiBold()),
              const TextSpan(text: 'atau cukup '),
              TextSpan(text: 'scan QR ', style: AppTextStyles.list1SemiBold()),
              const TextSpan(text: 'catering Sporky? Semuanya bisa!'),
            ])),
          ),
          const CmpMealForm()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, left: 16.0, right: 16.0),
        child: GlobalsButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMealCategoryPage(),
                ));
          },
          color: AppColors.secondary1,
          text: 'Hitung Kalori',
        ),
      ),
    );
  }
}
