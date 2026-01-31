import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/chart/nutrition_pie_chart.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ChildNutritionChart extends StatelessWidget {
  const ChildNutritionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final nutritionData = [
      NutritionData(
        name: 'Karbohidrat',
        iconPath: 'assets/svg/ic_nutrition.svg',
        value: 83,
        color: const Color(0xFF0E1C4D),
      ),
      NutritionData(
        name: 'Protein',
        iconPath: 'assets/svg/ic_proteins.svg',
        value: 151,
        color: const Color(0xFFFFB703),
      ),
      NutritionData(
        name: 'Lemak',
        iconPath: 'assets/svg/ic_fat.svg',
        value: 18,
        color: const Color(0xFFFFDD57),
      ),
    ];

    return GlobalsCard(
      backgroundColor: AppColors.base5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrisi Harian',
            style: AppTextStyles.heading2SemiBold(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              GlobalsCard(
                hasShadow: false,
                backgroundColor: AppColors.base4,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    const Text('Hari ini, 27, Juni 2025'),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/svg/ic_ calendar - schedule.svg',
                        height: 16,
                        width: 16,
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // PIE CHART
              SizedBox(
                height: 150,
                width: 150,
                child: NutritionPieChart(data: nutritionData),
              ),

              // LIST KANAN
              GlobalsCard(
                margin: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width / 2,
                hasShadow: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                backgroundColor: AppColors.base4,
                child: Column(
                  children: nutritionData
                      .map((item) => NutritionList(
                            iconPath: item.iconPath,
                            text: item.name,
                            value: item.value.toInt(),
                          ))
                      .toList(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NutritionList extends StatelessWidget {
  final String text;
  final int value;
  final String iconPath;

  const NutritionList(
      {super.key,
      required this.text,
      required this.value,
      required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
          Text('$value gr'),
        ],
      ),
    );
  }
}
