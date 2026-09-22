import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/hot_topic.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/more_article_cmp.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/special_for_mom.dart';

import '../../../components/globals/filter/category_filter_chips_horizontal.dart';
import '../../../components/globals/filter/filter_content_button.dart';
import '../../../components/globals/card/cmp_tag_category.dart';
import '../../../core/services/explore/explore_content_service.dart';
import '../../../models/components/explore/explore_content_model.dart';

class ArticlePage extends StatefulWidget {
  final String searchQuery;

  const ArticlePage({super.key, this.searchQuery = ''});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  int selectedIndex = 0;
  bool _sortByLikes = false;
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

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SortContentButton(
                  sortByLikes: _sortByLikes,
                  onChanged: (value) {
                    setState(() {
                      _sortByLikes = value;
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
          SpecialForMom(searchQuery: widget.searchQuery),
          const SizedBox(height: 16),
          MoreArticleCmp(
            searchQuery: widget.searchQuery,
            selectedTopicId: _selectedTopicId,
            sortByLikes: _sortByLikes,
          ),
        ],
      ),
    );
  }
}
