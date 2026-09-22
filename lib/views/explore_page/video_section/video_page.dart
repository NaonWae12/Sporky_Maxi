import 'package:flutter/material.dart';
import 'package:sporky_maxi/core/services/explore/explore_content_service.dart';
import 'package:sporky_maxi/models/components/explore/explore_content_model.dart';

import '../../../components/explore_cmp/video_cmp/content_vid_vert2.dart';
import '../../../components/explore_cmp/video_cmp/short_vid_content_more_views.dart';
import '../../../components/explore_cmp/video_cmp/short_vid_content_special.dart';
import '../../../components/globals/card/cmp_tag_category.dart';
import '../../../components/globals/filter/category_filter_chips_horizontal.dart';
import '../../../components/globals/filter/filter_content_button.dart';

class VideoPage extends StatefulWidget {
  final String searchQuery;

  const VideoPage({super.key, this.searchQuery = ''});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  static const ExploreContentService _service = ExploreContentService();

  int selectedIndex = 0;
  bool _sortByLikes = false;
  List<ExploreTopic> _topics = const [ExploreTopic(id: null, name: 'Semua')];
  bool _topicsLoading = true;

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

  Map<String, dynamic>? get _selectedTopic {
    if (selectedIndex == 0) return null;
    if (selectedIndex < _topics.length) {
      final topic = _topics[selectedIndex];
      return {'id': topic.id, 'name': topic.name};
    }
    return null;
  }

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
            text: 'Sedang Banyak Ditonton',
          ),
          ShortVidContentMoreViews(searchQuery: widget.searchQuery),
          const CmpTagCategory(
            imageAsset: 'assets/svg/sun.svg',
            text: 'Spesial Untuk Bunda & Si Kecil',
          ),
          ShortVidContentSpecial(searchQuery: widget.searchQuery),
          const SizedBox(height: 16),
          ContentVidVert2(
            searchQuery: widget.searchQuery,
            selectedTopic: _selectedTopic,
            sortByLikes: _sortByLikes,
          ),
        ],
      ),
    );
  }
}
