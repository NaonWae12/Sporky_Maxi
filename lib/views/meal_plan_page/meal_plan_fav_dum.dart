// import 'package:flutter/material.dart';
// import 'package:sporky_maxi/components/globals/text/text_style.dart';

// import '../../components/globals/form/search_input.dart';
// import '../../components/meal_plan_cmp/cmp_card_list_article.dart';

// class MealPlanFav extends StatefulWidget {
//   const MealPlanFav({super.key});

//   @override
//   State<MealPlanFav> createState() => _MealPlanFavState();
// }

// class _MealPlanFavState extends State<MealPlanFav> {
//   TextEditingController searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: MediaQuery.of(context).size.width,
//         leading: Row(
//           children: [
//             const SizedBox(width: 5),
//             IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.arrow_back_ios)),
//             Text(
//               'Meal Plan Favorit',
//               style: AppTextStyles.heading2SemiBold(),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SearchInput(
//                 showHeartIcon: false,
//                 hintText: 'brokoli pasta',
//                 controller: searchController,
//                 onHeartPressed: () {}),
//             CmpCardListArticle(
//               onTap: () {},
//               imageAsset: 'assets/temp_img/meal2.png',
//               meal: 'Cemilan Sore',
//               views: 1200,
//               likes: 567,
//               kal: 145,
//               title: "Mix Platter-1",
//               description:
//                   'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
//             ),
//             CmpCardListArticle(
//               onTap: () {},
//               imageAsset: 'assets/temp_img/meal1.png',
//               meal: 'Cemilan Pagi',
//               views: 1200,
//               likes: 567,
//               kal: 145,
//               title: "Mix Platter-1",
//               description:
//                   'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
//             ),
//             CmpCardListArticle(
//               onTap: () {},
//               meal: 'Cemilan Pagi',
//               views: 1200,
//               likes: 567,
//               kal: 145,
//               title: "Mix Platter-1",
//               description:
//                   'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
