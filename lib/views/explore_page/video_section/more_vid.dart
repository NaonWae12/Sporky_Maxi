// tidak digunakan lagi karena sudah digabung dengan more vid page cmp
// import 'package:flutter/material.dart';
// import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
// import 'package:sporky_maxi/components/globals/colors/colors.dart';
// import 'package:sporky_maxi/components/globals/text/text_style.dart';

// import '../../../components/explore_cmp/video_cmp/more_vid_page_cmp.dart';
// import '../../../components/globals/filter/category_filter_chips_horizontal.dart';
// import '../../../components/globals/filter/filter_content_button.dart';

// class MoreVid extends StatefulWidget {
//   const MoreVid({super.key});

//   @override
//   State<MoreVid> createState() => _MoreVidState();
// }

// class _MoreVidState extends State<MoreVid> {
//   int selectedIndex = 0;
//   List<String> _selectedFiltersFromBottomSheet = [];

//   final List<String> filters = [
//     'Semua',
//     'Nutrisi Anak',
//     'Tema 2',
//     'Tema 1',
//     'Tema Lain',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//             CategoryFilterChipsHorizontal(
//               categories: filters,
//               selectedIndex: selectedIndex,
//               onSelected: (index) {
//                 setState(() {
//                   selectedIndex = index;
//                 });
//               },
//             ),
//             const SizedBox(height: 10),
//             // Text('Filter aktif: ${filters[selectedIndex]}'),

//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: _selectedFiltersFromBottomSheet.isNotEmpty
//                         ? Wrap(
//                             spacing: 6,
//                             runSpacing: 4,
//                             children: _selectedFiltersFromBottomSheet
//                                 .map(
//                                   (filter) => GlobalsCardOutlined(
//                                     height: 24,
//                                     borderColor: Colors.transparent,
//                                     backgroundColor: AppColors.secondary2,
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(filter,
//                                             style: AppTextStyles.list1Regular(
//                                                 AppColors.base5)),
//                                         IconButton(
//                                           icon: const Icon(Icons.close,
//                                               size: 15, color: AppColors.base5),
//                                           padding: EdgeInsets.zero,
//                                           constraints: const BoxConstraints(),
//                                           onPressed: () {
//                                             setState(() {
//                                               _selectedFiltersFromBottomSheet
//                                                   .remove(filter);
//                                             });
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           )
//                         : const SizedBox(), // biar gak ganggu kalau kosong
//                   ),
//                   const SizedBox(width: 8),
//                   FilterContentButton(
//                     categories: const ['sdfg', 'adfads'],
//                     title: 'Urutkan Berdasarkan',
//                     onFilterApplied: (selected) {
//                       setState(() {
//                         _selectedFiltersFromBottomSheet = selected;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             const MoreVidPageCmp()
//           ],
//         ),
//       ),
//     );
//   }
// }
