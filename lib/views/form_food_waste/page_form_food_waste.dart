import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

import '../../components/form_food_waste_cmp/first_form_cmp.dart';
import '../../components/globals/card/cmp_tag_attention.dart';
import '../../components/globals/text/text_style.dart';

class PageFormFoodWaste extends StatelessWidget {
  const PageFormFoodWaste({super.key});

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
          const FirstFormCmp()
        ],
      ),
    );
  }
}
