// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class BottomContentMeal extends StatelessWidget {
  const BottomContentMeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
          child: GlobalsCard(
        padding: EdgeInsets.all(8),
        backgroundColor: AppColors.base4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                    height: 18,
                    width: 18,
                    child: SvgPicture.asset('assets/svg/compass-rounded.svg')),
                Text(
                  'Sudah Selesai Memasak?',
                  style: AppTextStyles.heading3SemiBold(),
                ),
              ],
            ),
            Text(
              'Yuk catat berapa banyak yang dimakan anak hari ini!',
              style: AppTextStyles.list1Regular(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: GlobalsButton(
                height: 32,
                width: MediaQuery.of(context).size.width / 1.2,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 16,
                        width: 16,
                        child: SvgPicture.asset(
                          'assets/svg/ic_pie_chart.svg',
                          colorFilter: ColorFilter.mode(
                              AppColors.base5, BlendMode.srcIn),
                        )),
                    const SizedBox(width: 5),
                    Text(
                      'Catat Kalori Harian',
                      style: AppTextStyles.list1Bold(AppColors.base5),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
