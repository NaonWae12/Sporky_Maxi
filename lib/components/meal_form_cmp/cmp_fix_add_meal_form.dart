// import 'package:flutter/material.dart';
// import 'package:sporky_maxi/components/globals/card/globals_card.dart';
// import 'package:sporky_maxi/components/globals/form/globals_form.dart';

// import '../globals/colors/colors.dart';
// import '../globals/text/text_style.dart';

// class CmpFixAddMealForm extends StatefulWidget {
//   const CmpFixAddMealForm({
//     super.key,
//   });

//   @override
//   State<CmpFixAddMealForm> createState() => _CmpFixAddMealFormFormState();
// }

// class _CmpFixAddMealFormFormState extends State<CmpFixAddMealForm> {
//   TextEditingController mealNameController = TextEditingController();
//   TextEditingController portionsController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: GlobalsForm(
//                   hasShadow: false,
//                   controller: mealNameController,
//                   label: 'Nama Menu',
//                   keyboardType: TextInputType.number,
//                   // labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
//                 ),
//               ),
//               // const SizedBox(width: 8),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: GlobalsForm(
//                         width: 140,
//                         hasShadow: false,
//                         controller: portionsController,
//                         label: '1',
//                         keyboardType: TextInputType.number,
//                         // labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
//                       ),
//                     ),
//                     Positioned(
//                       right: 0,
//                       child: GlobalsCard(
//                           backgroundColor: AppColors.primary1,
//                           width: 95,
//                           hasShadow: false,
//                           height: 55,
//                           margin: const EdgeInsets.all(0),
//                           child: Center(
//                             child: Text(
//                               'Porsi',
//                               style: AppTextStyles.heading3SemiBold(
//                                   AppColors.base5),
//                             ),
//                           )),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: GlobalsForm(
//                   hasShadow: false,
//                   controller: mealNameController,
//                   label: 'Nama Menu',
//                   keyboardType: TextInputType.number,
//                   // labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: GlobalsForm(
//                         width: 140,
//                         hasShadow: false,
//                         controller: portionsController,
//                         label: '1',
//                         keyboardType: TextInputType.number,
//                         // labelStyle: AppTextStyles.lable3Medium(AppColors.base2),
//                       ),
//                     ),
//                     Positioned(
//                       right: 0,
//                       child: GlobalsCard(
//                           backgroundColor: AppColors.primary1,
//                           width: 95,
//                           hasShadow: false,
//                           height: 55,
//                           margin: const EdgeInsets.all(0),
//                           child: Center(
//                             child: Text(
//                               'Porsi',
//                               style: AppTextStyles.heading3SemiBold(
//                                   AppColors.base5),
//                             ),
//                           )),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
