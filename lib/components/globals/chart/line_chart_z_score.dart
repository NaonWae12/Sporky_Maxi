// tidak digunakan
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartZScore extends StatelessWidget {
  const LineChartZScore({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 32,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  switch (value.toInt()) {
                    case 8:
                      return const Text('8');
                    case 9:
                      return const Text('9');
                    case 10:
                      return const Text('10');
                    case 11:
                      return const Text('11');
                    case 12:
                      return const Text('12');
                    case 13:
                      return const Text('13');
                    case 14:
                      return const Text('14');
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
          minX: 8,
          maxX: 14,
          minY: -3,
          maxY: 3,
          // Tambahkan garis horizontal pada y=0
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Colors.grey,
              strokeWidth: 1,
            )
          ]),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.orange,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.orange.withValues(alpha: 0.3 * 255.round()),
                applyCutOffY: true,
                cutOffY: 0,
              ),
              spots: const [
                FlSpot(8, 0.5),
                FlSpot(9, -2.5),
                FlSpot(10, -0.5),
                FlSpot(11, 2.5),
                FlSpot(12, -1.8),
                FlSpot(13, 1.6),
                FlSpot(14, -0.5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
