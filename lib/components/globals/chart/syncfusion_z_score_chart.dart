import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionZScoreChart extends StatelessWidget {
  final List<ChartData> data;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final double intervalX;
  final double intervalY;
  final Color? lineColor;
  final Color? fillColor;

  const SyncfusionZScoreChart({
    super.key,
    required this.data,
    this.minX = 8,
    this.maxX = 14,
    this.minY = -3,
    this.maxY = 3,
    this.intervalX = 1,
    this.intervalY = 1,
    this.lineColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: false,
      ),
      primaryXAxis: NumericAxis(
        minimum: minX,
        maximum: maxX,
        interval: intervalX,
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.grey.withAlpha(62),
          dashArray: [5, 3],
        ),
      ),
      primaryYAxis: NumericAxis(
        minimum: minY,
        maximum: maxY,
        interval: intervalY,
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.grey.withAlpha(62),
          dashArray: [5, 3],
        ),
        plotBands: <PlotBand>[
          PlotBand(
            isVisible: true,
            start: 0,
            end: 0,
            borderWidth: 1,
            borderColor: Colors.grey,
          ),
        ],
      ),
      axes: <ChartAxis>[
        NumericAxis(
          name: 'secondary',
          opposedPosition: true,
          isVisible: false,
        ),
      ],
      plotAreaBorderWidth: 0,
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: const SizedBox(
            width: double.infinity,
            height: 1,
          ),
          coordinateUnit: CoordinateUnit.point,
          region: AnnotationRegion.chart,
          x: minX,
          y: 0,
        ),
      ],
      series: <CartesianSeries>[
        SplineAreaSeries<ChartData, double>(
          dataSource: data,
          xValueMapper: (ChartData d, _) => d.x,
          yValueMapper: (ChartData d, _) => d.y,
          borderColor: (lineColor ?? AppColors.primary1).withAlpha(200),
          borderWidth: 2,
          enableTooltip: true,
          color: (fillColor ?? AppColors.primary2).withAlpha(200),
          markerSettings: MarkerSettings(
            isVisible: true,
            color: fillColor ?? AppColors.primary2,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              fillColor ?? AppColors.primary2,
              (fillColor ?? AppColors.primary2).withAlpha(70),
            ],
          ),
        )
      ],
    );
  }
}

class ChartData {
  final double x;
  final double y;

  ChartData(this.x, this.y);
}
