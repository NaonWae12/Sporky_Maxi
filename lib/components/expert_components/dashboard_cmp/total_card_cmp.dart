import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class TotalCardCmp extends StatelessWidget {
  final String count;
  const TotalCardCmp({super.key, this.count = '0'});

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      margin: EdgeInsets.all(0),
      height: 70,
      width: 110,
      hasShadow: false,
      backgroundColor: AppColors.base5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Total',
              style: AppTextStyles.lable2Medium(),
            ),
            Text(
              count,
              style:
                  AppTextStyles.upperDisplay1SemiBold().copyWith(height: 1.0),
            )
          ],
        ),
      ),
    );
  }
}
