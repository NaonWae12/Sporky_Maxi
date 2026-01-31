// import 'package:flutter/material.dart';
// import 'nutrition_pie_chart.dart'; // penting: import model NutritionData

// class NutritionLegendList extends StatelessWidget {
//   final List<NutritionData> data;
//   final Map<String, IconData>? icons; // optional

//   const NutritionLegendList({
//     super.key,
//     required this.data,
//     this.icons,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: data.map((item) {
//         final icon = icons?[item.name] ?? Icons.circle; // default icon
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, color: item.color, size: 18),
//               const SizedBox(width: 8),
//               Text(
//                 '${item.name}: ${item.value.toStringAsFixed(0)} g',
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
