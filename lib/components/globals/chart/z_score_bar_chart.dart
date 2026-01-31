import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../colors/colors.dart';

class ZScoreBarChart extends StatelessWidget {
  final List<ZScoreBarChartData> data;
  final double minY;
  final double maxY;
  final double intervalY;
  final Color? barColor;
  final Color? trackColor;
  final double barWidth;
  final double borderRadius;

  const ZScoreBarChart({
    super.key,
    required this.data,
    this.minY = 0,
    this.maxY = 100,
    this.intervalY = 20,
    this.barColor,
    this.trackColor,
    this.barWidth = 0.3,
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: false,
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(fontSize: 12),
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: minY,
        maximum: maxY,
        interval: intervalY,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries>[
        ColumnSeries<ZScoreBarChartData, String>(
          dataSource: data,
          xValueMapper: (ZScoreBarChartData d, _) => d.x.toString(),
          yValueMapper: (ZScoreBarChartData d, _) => d.y,
          name: 'Z-Score',
          borderRadius: BorderRadius.circular(borderRadius),
          width: barWidth,
          color: barColor ?? AppColors.primary1,
          enableTooltip: true,
          isTrackVisible: true,
          trackColor:
              trackColor ?? (barColor ?? AppColors.primary1).withAlpha(26),
        ),
      ],
    );
  }
}

class ZScoreBarChartData {
  final int x;
  final double y;

  ZScoreBarChartData(this.x, this.y);
}
