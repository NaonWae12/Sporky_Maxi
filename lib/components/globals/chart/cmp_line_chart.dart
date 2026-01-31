// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class CmpLineChart extends StatelessWidget {
//   final String title;
//   final String legend;
//   final List<ChartSampleData> data;
//   final Color lineColor;
//   final Color fillColor;
//   final Color dotColor;

//   const CmpLineChart({
//     super.key,
//     required this.title,
//     required this.legend,
//     required this.data,
//     this.lineColor = Colors.orange,
//     this.fillColor = const Color(0x44FFA500),
//     this.dotColor = Colors.orange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.orange,
//               ),
//             ),
//             const Icon(Icons.arrow_drop_down, color: Colors.orange),
//           ],
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 200,
//           child: SfCartesianChart(
//             primaryXAxis: const NumericAxis(),
//             primaryYAxis: const NumericAxis(),
//             legend: const Legend(
//               isVisible: true,
//               position: LegendPosition.bottom,
//               overflowMode: LegendItemOverflowMode.wrap,
//             ),
//             tooltipBehavior: TooltipBehavior(enable: true),
//             series: <CartesianSeries>[
//               SplineAreaSeries<ChartSampleData, double>(
//                 dataSource: data,
//                 xValueMapper: (ChartSampleData data, _) => data.x,
//                 yValueMapper: (ChartSampleData data, _) => data.y,
//                 borderColor: lineColor,
//                 borderWidth: 2,
//                 color: fillColor,
//                 markerSettings: MarkerSettings(
//                   isVisible: true,
//                   height: 8,
//                   width: 8,
//                   borderColor: Colors.white,
//                   shape: DataMarkerType.circle,
//                   color: dotColor,
//                 ),
//                 name: legend,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ChartSampleData {
//   final double x;
//   final double y;

//   ChartSampleData(this.x, this.y);
// }
