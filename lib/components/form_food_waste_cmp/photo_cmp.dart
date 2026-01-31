import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PhotoCmp extends StatelessWidget {
  const PhotoCmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        GlobalsCard(
            backgroundColor: AppColors.base4,
            height: 343,
            width: 343,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt,
                    size: 36, color: AppColors.primary1),
                Text(
                  'Buka Galeri',
                  style: AppTextStyles.list1Regular(AppColors.primary1),
                )
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Pastikan foto diambil dari atas dan pencahayaan cukup agar hasil analisis lebih akurat ya, Bunda!',
            style: AppTextStyles.list3Regular(AppColors.base2),
            overflow: TextOverflow.clip,
          ),
        ),
        const SizedBox(height: 15),
        GlobalsButton(
          width: MediaQuery.of(context).size.width / 1.1,
          onPressed: () {},
          text: 'Upload Foto Sisa Makanan',
          color: AppColors.secondary1,
          textColor: AppColors.base5,
        )
      ],
    );
  }
}
