import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/chart/nutrition_pie_chart.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ChildNutritionChart extends StatelessWidget {
  final double carbohydrate;
  final double protein;
  final double fat;
  final bool hasData;
  final bool isLoading;
  final DateTime selectedDate;
  final VoidCallback onPrevDay;
  final VoidCallback onNextDay;

  const ChildNutritionChart({
    super.key,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.selectedDate,
    required this.onPrevDay,
    required this.onNextDay,
    this.hasData = true,
    this.isLoading = false,
  });

  String _formatDisplayDate() {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final monthName = months[selectedDate.month - 1];
    final dateStr = '${selectedDate.day} $monthName ${selectedDate.year}';

    return isToday ? 'Hari ini, $dateStr' : dateStr;
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = !hasData || (carbohydrate == 0 && protein == 0 && fat == 0);

    final List<NutritionData> nutritionData = isEmpty
        ? [
            NutritionData(
              name: 'Belum ada data',
              iconPath: 'assets/svg/ic_nutrition.svg',
              value: 1,
              color: const Color(0xFFD0D0D0),
            ),
          ]
        : [
            NutritionData(
              name: 'Karbohidrat',
              iconPath: 'assets/svg/ic_nutrition.svg',
              value: carbohydrate,
              color: const Color(0xFF0E1C4D),
            ),
            NutritionData(
              name: 'Protein',
              iconPath: 'assets/svg/ic_proteins.svg',
              value: protein,
              color: const Color(0xFFFFB703),
            ),
            NutritionData(
              name: 'Lemak',
              iconPath: 'assets/svg/ic_fat.svg',
              value: fat,
              color: const Color(0xFFFFDD57),
            ),
          ];

    return GlobalsCard(
      backgroundColor: AppColors.base5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Nutrisi Harian',
                style: AppTextStyles.heading2SemiBold(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: isLoading ? null : onPrevDay,
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              GlobalsCard(
                hasShadow: false,
                backgroundColor: AppColors.base4,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    Text(_formatDisplayDate()),
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
                onPressed: isLoading ? null : onNextDay,
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            )
          else
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
                  child: isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Belum ada konsumsi\nharian hari ini',
                            style: AppTextStyles.list1Regular(AppColors.base2),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Column(
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
