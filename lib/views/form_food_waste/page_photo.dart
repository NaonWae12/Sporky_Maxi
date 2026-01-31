import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

import '../../components/form_food_waste_cmp/photo_cmp.dart';
import '../../components/globals/text/text_style.dart';

class PagePhoto extends StatelessWidget {
  const PagePhoto({super.key});

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
                'Foto Sisa Makanan',
                style: AppTextStyles.heading2SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CmpTagAttention(
            imageAsset: 'assets/svg/ic_warn.svg',
            sizeImage: 24,
            wrapText: 1.21,
            imageColor: AppColors.info1,
            child: Text.rich(
                TextSpan(style: AppTextStyles.list1Regular(), children: [
              const TextSpan(
                  text:
                      'Yuk dokumentasikan sisa makanannya, biar Sporky bantu analisis pola makannya! Dan dapatkan '),
              TextSpan(
                text: '+20 xp!',
                style: AppTextStyles.list1_1Bold(null, FontStyle.italic),
              ),
            ])),
          ),
          const PhotoCmp()
        ],
      ),
    );
  }
}
