import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ChildDevelopmentCmp extends StatelessWidget {
  final String zScore;
  final String weight;
  final String height;

  const ChildDevelopmentCmp({
    super.key,
    required this.zScore,
    required this.weight,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double parsedZ = double.tryParse(zScore) ?? 0;
    final Color zColor = parsedZ < 1 ? AppColors.success1 : AppColors.warn1;

    final double screenWidth = MediaQuery.of(context).size.width;

    return GlobalsCard(
      hasShadow: false,
      backgroundColor: AppColors.base4,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Z-Score Card (centered)
          _InfoCard(
            width: screenWidth / 4.5,
            title: 'Z-Score',
            value: zScore,
            backgroundColor: zColor,
            isTitleBold: true,
            alignCenter: true,
            titleColor: AppColors.base5,
            valueColor: AppColors.base5,
          ),

          // 🔹 Berat Badan Card
          _InfoCard(
            width: screenWidth / 3.5,
            title: 'Berat Badan',
            value: weight,
            unit: 'kg',
          ),

          // 🔹 Tinggi Badan Card
          _InfoCard(
            width: screenWidth / 3.5,
            title: 'Tinggi Badan',
            value: height,
            unit: 'cm',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final double width;
  final bool isTitleBold;
  final bool alignCenter;
  final Color backgroundColor;
  final Color? titleColor;
  final Color? valueColor;

  const _InfoCard({
    required this.title,
    required this.value,
    this.unit,
    required this.width,
    this.isTitleBold = false,
    this.alignCenter = false,
    this.backgroundColor = AppColors.base5,
    this.titleColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      width: width,
      hasShadow: false,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            alignCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔹 Title
          Text(
            title,
            style: isTitleBold
                ? AppTextStyles.list1Bold(titleColor ?? AppColors.base1)
                : AppTextStyles.list1Regular(titleColor ?? AppColors.base1),
          ),
          const SizedBox(height: 2),

          // 🔹 Value + unit
          Row(
            mainAxisAlignment: alignCenter
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.heading1SemiBold(
                  valueColor ?? AppColors.base1,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 3),
                Text(
                  unit!,
                  style: AppTextStyles.heading3Regular(
                    valueColor ?? AppColors.base1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
