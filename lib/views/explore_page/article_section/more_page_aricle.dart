import 'package:flutter/material.dart';

import '../../../components/explore_cmp/article_cmp/more_article_cmp.dart';
import '../../../components/globals/card/globals_card_outlined.dart';
import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/filter/category_filter_chips_horizontal.dart';
import '../../../components/globals/filter/filter_content_button.dart';
import '../../../components/globals/form/search_input.dart';
import '../../../components/globals/text/text_style.dart';
import 'article_fav.dart';

class MorePageAricle extends StatefulWidget {
  final String searchQuery;

  const MorePageAricle({
    super.key,
    this.searchQuery = '',
  });

  @override
  State<MorePageAricle> createState() => _MorePageAricleState();
}

class _MorePageAricleState extends State<MorePageAricle> {
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

          MoreArticleCmp(searchQuery: widget.searchQuery)
        ],
      ),
    );
  }
}

class MoreArticlePage extends StatefulWidget {
  const MoreArticlePage({super.key});

  @override
  State<MoreArticlePage> createState() => _MoreArticlePageState();
}

class _MoreArticlePageState extends State<MoreArticlePage> {
  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: SearchInput(
          onLeadingPressed: () => Navigator.pop(context),
          showLeadingIcon: true,
          controller: searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onHeartPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ArticleFav()),
            );
          },
        ),
      ),
      body: MorePageAricle(searchQuery: _searchQuery),
    );
  }
}
