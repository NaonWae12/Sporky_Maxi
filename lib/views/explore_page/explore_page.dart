import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/explore_page/article_section/article_page.dart';

import 'article_section/article_fav.dart';
import 'video_section/video_fav.dart';
import 'video_section/video_page.dart';
import '../../components/globals/bar/full_width_tab_bar.dart';
import '../../components/globals/form/search_input.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;
  String _videoSearchQuery = '';
  String _articleSearchQuery = '';

  // final List<String> filters = [
  //   'Semua',
  //   'Nutrisi Anak',
  //   'Tema 2',
  //   'Tema 1',
  //   'Tema Lain',
  // ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _syncSearchFieldWithActiveTab() {
    final activeQuery =
        selectedIndex == 0 ? _videoSearchQuery : _articleSearchQuery;
    if (searchController.text == activeQuery) return;
    searchController.value = TextEditingValue(
      text: activeQuery,
      selection: TextSelection.collapsed(offset: activeQuery.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            const SizedBox(height: 15),
            SearchInput(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  if (selectedIndex == 0) {
                    _videoSearchQuery = value;
                  } else {
                    _articleSearchQuery = value;
                  }
                });
              },
              onHeartPressed: () {
                if (selectedIndex == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const VideoFav()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ArticleFav()));
                }
              },
            ),
            Expanded(
              child: FullWidthTabBar(
                tabs: const ['Video', 'Artikel'],
                tabViews: [
                  VideoPage(searchQuery: _videoSearchQuery),
                  ArticlePage(searchQuery: _articleSearchQuery),
                ],
                onTabChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  _syncSearchFieldWithActiveTab();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
