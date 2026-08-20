import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/hot_topic.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/special_for_mom.dart';

import '../../../components/globals/card/globals_card_outlined.dart';
import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/filter/category_filter_chips_horizontal.dart';
import '../../../components/globals/filter/filter_content_button.dart';
import '../../../components/globals/card/cmp_tag_category.dart';
import '../../../components/globals/text/text_style.dart';

class ArticlePage extends StatefulWidget {
  final String searchQuery;

  const ArticlePage({
    super.key,
    this.searchQuery = '',
  });

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  int selectedIndex = 0;
  List<String> _selectedFiltersFromBottomSheet = [];
  final List<String> filters = [
    'Semua',
    'Pola Asuh',
    'Tema 2',
    'Tema 1',
    'Tema Lain',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          CategoryFilterChipsHorizontal(
            categories: filters,
            selectedIndex: selectedIndex,
            onSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          const SizedBox(height: 10),
          // Text('Filter aktif: ${filters[selectedIndex]}'),

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
          const CmpTagCategory(
            imageAsset: 'assets/svg/ic_ rocket.svg',
            text: 'Topik Hangat untuk Bunda',
          ),
          HotTopic(searchQuery: widget.searchQuery),
          const CmpTagCategory(
            imageAsset: 'assets/svg/sun.svg',
            text: 'Topik Hangat untuk Bunda',
          ),
          SpecialForMom(searchQuery: widget.searchQuery)
        ],
      ),
    );
  }
}
