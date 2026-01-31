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

  final List<String> filters = [
    'Semua',
    'Nutrisi Anak',
    'Tema 2',
    'Tema 1',
    'Tema Lain',
  ];
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
                tabViews: const [
                  VideoPage(),
                  ArticlePage(),
                ],
                onTabChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
