import 'package:flutter/material.dart';

import '../../../components/explore_cmp/article_cmp/more_article_cmp.dart';
import '../../../components/globals/card/globals_card_outlined.dart';
import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/filter/category_filter_chips_horizontal.dart';
import '../../../components/globals/filter/filter_content_button.dart';
import '../../../components/globals/form/search_input.dart';
import '../../../components/globals/text/text_style.dart';
import '../../../core/services/explore/explore_content_service.dart';
import '../../../models/components/explore/explore_content_model.dart';
import 'article_fav.dart';

class MorePageAricle extends StatefulWidget {
  final String searchQuery;

  const MorePageAricle({super.key, this.searchQuery = ''});

  @override
  State<MorePageAricle> createState() => _MorePageAricleState();
}

class _MorePageAricleState extends State<MorePageAricle> {
  int selectedIndex = 0;
  List<String> _selectedFiltersFromBottomSheet = [];
  List<ExploreTopic> _topics = const [ExploreTopic(id: null, name: 'Semua')];
  bool _topicsLoading = true;
  static const ExploreContentService _service = ExploreContentService();

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    try {
      final topics = await _service.getTopics();
      if (mounted) {
        setState(() {
          _topics = [const ExploreTopic(id: null, name: 'Semua'), ...topics];
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _topics = const [ExploreTopic(id: null, name: 'Semua')];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _topicsLoading = false;
        });
      }
    }
  }

  int? get _selectedTopicId => _topics[selectedIndex].id;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _topicsLoading
              ? const SizedBox(
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : CategoryFilterChipsHorizontal(
                  categories: _topics.map((topic) => topic.name).toList(),
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
                                      Text(
                                        filter,
                                        style: AppTextStyles.list1Regular(
                                          AppColors.base5,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: AppColors.base5,
                                        ),
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

          MoreArticleCmp(
            searchQuery: widget.searchQuery,
            selectedTopicId: _selectedTopicId,
          ),
        ],
      ),
    );
  }
}

class MoreArticlePage extends StatefulWidget {
  final String? initialSearchQuery;

  const MoreArticlePage({super.key, this.initialSearchQuery});

  @override
  State<MoreArticlePage> createState() => _MoreArticlePageState();
}

class _MoreArticlePageState extends State<MoreArticlePage> {
  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialSearchQuery ?? '';
    searchController.text = _searchQuery;
  }

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
