import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/views/form_food_waste/page_add_form_food_waste.dart';

import '../../components/form_food_waste_cmp/first_form_cmp.dart';
import '../../components/globals/card/cmp_tag_attention.dart';
import '../../components/globals/text/text_style.dart';
import '../summary_of_daily/page_summary.dart';

class PageFormFoodWaste extends StatefulWidget {
  const PageFormFoodWaste({super.key});

  @override
  State<PageFormFoodWaste> createState() => _PageFormFoodWasteState();
}

class _PageFormFoodWasteState extends State<PageFormFoodWaste> {
  FoodWasteMealOption? _selectedMealOption;

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
                'Form Sisa Makanan',
                style: AppTextStyles.heading2SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CmpTagAttention(
              imageAsset: 'assets/ic_food_waste1.png',
              lineColor: AppColors.warn1,
              imageColor: AppColors.warn1,
              child: Text.rich(
                  TextSpan(style: AppTextStyles.list1Regular(), children: [
                const TextSpan(text: 'Dengan mencatat '),
                TextSpan(
                    text: 'makanan yang tidak habis',
                    style: AppTextStyles.list1Bold()),
                const TextSpan(
                    text:
                        ', kamu bisa membantu memantau pertumbuhan si kecil. Yuk, isi '),
                TextSpan(
                    text: 'form sisa makanan ',
                    style: AppTextStyles.list1Bold()),
                const TextSpan(text: 'hari ini!'),
              ]))),
          FirstFormCmp(
            selectedMealOption: _selectedMealOption,
            onMealOptionChanged: (option) {
              setState(() {
                _selectedMealOption = option;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalsButton(
              onPressed: _selectedMealOption == null
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageAddFormFoodWaste(
                                    selectedMealOption: _selectedMealOption,
                                  )));
                    },
              color: _selectedMealOption == null
                  ? AppColors.base2
                  : AppColors.secondary1,
              text: 'Data Sisa Makanan',
            ),
            // =============== Next to Page Summary ===============
            const SizedBox(height: 8),
            Text.rich(TextSpan(
              style: AppTextStyles.list1Regular(),
              children: [
                TextSpan(text: 'Mau Lihat Data Ringkasan Anak? '),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageSummary(),
                            ));
                      },
                    text: 'klik disini',
                    style: AppTextStyles.list1SemiBold(AppColors.primary1))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
