import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/cmp_card_list_article.dart';

import '../../../components/globals/card/globals_card_outlined.dart';
import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/filter/filter_content_button.dart';
import '../../../components/globals/text/text_style.dart';

class AllContentPage extends StatefulWidget {
  const AllContentPage({super.key});

  @override
  State<AllContentPage> createState() => _AllContentPageState();
}

class _AllContentPageState extends State<AllContentPage> {
  List<String> _selectedFiltersFromBottomSheet = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _selectedFiltersFromBottomSheet.isNotEmpty
                      ? Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _selectedFiltersFromBottomSheet
                              .map(
                                (filter) => GlobalsCardOutlined(
                                  height: 24,
                                  borderColor: Colors.transparent,
                                  backgroundColor: AppColors.secondary2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(filter,
                                          style: AppTextStyles.list1Regular(
                                              AppColors.base5)),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            size: 15, color: AppColors.base5),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            _selectedFiltersFromBottomSheet
                                                .remove(filter);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const SizedBox(), // biar gak ganggu kalau kosong
                ),
                const SizedBox(width: 8),
                FilterContentButton(
                  categories: const ['sdfg', 'adfads'],
                  title: 'Urutkan Berdasarkan',
                  onFilterApplied: (selected) {
                    setState(() {
                      _selectedFiltersFromBottomSheet = selected;
                    });
                  },
                ),
              ],
            ),
          ),
          CmpCardListArticle(
            onTap: () {},
            imageAsset: 'assets/temp_img/meal2.png',
            meal: 'Cemilan Pagi',
            views: 1200,
            likes: 567,
            kal: 145,
            title: "Mix Platter-1",
            description:
                'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
          ),
          CmpCardListArticle(
            onTap: () {},
            imageAsset: 'assets/temp_img/meal1.png',
            meal: 'Cemilan Pagi',
            views: 1200,
            likes: 567,
            kal: 145,
            title: "Mix Platter-1",
            description:
                'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
          ),
          CmpCardListArticle(
            onTap: () {},
            meal: 'Cemilan Pagi',
            views: 1200,
            likes: 567,
            kal: 145,
            title: "Mix Platter-1",
            description:
                'Paket lengkap kaya rasa berisi sandwich isi protein, jeruk segar, dan timun renyah untuk asupan gizi seimbang dan menyegarkan di waktu makan anak.',
          ),
        ],
      ),
    );
  }
}
