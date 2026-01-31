import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NutritionData {
  final String name;
  final double value;
  final Color color;
  final String iconPath;

  NutritionData({
    required this.name,
    required this.value,
    required this.color,
    required this.iconPath,
  });
}

class NutritionPieChart extends StatelessWidget {
  final List<NutritionData> data;

  const NutritionPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double total = data.fold(0, (sum, item) => sum + item.value);

    return SfCircularChart(
      margin: EdgeInsets.all(0),
      tooltipBehavior:
          TooltipBehavior(enable: true, format: 'point.x : point.y gr'),
      legend: Legend(
        isVisible: false,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom,
      ),
      series: <PieSeries<NutritionData, String>>[
        PieSeries<NutritionData, String>(
          dataSource: data,
          radius: '90%',
          xValueMapper: (NutritionData d, _) => d.name,
          yValueMapper: (NutritionData d, _) => d.value,
          pointColorMapper: (NutritionData d, _) => d.color,
          dataLabelMapper: (NutritionData d, _) =>
              '${((d.value / total) * 100).toStringAsFixed(1)}%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
          enableTooltip: true,
          explode: true,
          explodeAll: true,
          explodeOffset: '2%',
        )
      ],
    );
  }
}
