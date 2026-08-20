import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

import '../../../views/explore_page/video_section/detail_page.dart';
import 'more_vid_page_cmp.dart';
import '../../globals/card/video_card_item.dart';

class ShortVidContentSpecial extends StatelessWidget {
  final int limit;
  final String searchQuery;

  const ShortVidContentSpecial({
    super.key,
    this.limit = 1,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> videos = [
      {
        'image': 'assets/temp_img/picky_eater.png',
        'categories': ['Nutrisi Anak', 'Picky Eater'],
        'views': 1200,
        'likes': 567,
        'title': 'Picky Eater Bukan Masalah!',
        'desc':
            'Jangan panik, picky eater bisa diatasi dengan cara fun dan lembut!',
      },
      {
        'image': 'assets/temp_img/picky_eater.png',
        'categories': ['Nutrisi Anak', 'Picky Eater'],
        'views': 1200,
        'likes': 567,
        'title': 'Picky Eater Bukan Masalah!',
        'desc':
            'Jangan panik, picky eater bisa diatasi dengan cara fun dan lembut!',
      },
    ];

    final query = searchQuery.trim().toLowerCase();
    final filteredVideos = query.isEmpty
        ? videos
        : videos.where((video) {
            final title = (video['title']?.toString() ?? '').toLowerCase();
            final description = (video['desc']?.toString() ?? '').toLowerCase();
            return title.contains(query) || description.contains(query);
          }).toList();

    final displayedVideos = filteredVideos.take(limit).toList();

    return Column(
      children: [
        if (filteredVideos.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Tidak ada video yang cocok'),
          ),
        ...displayedVideos.map(
          (video) => VideoCardItem(
            mediaUrl: video['image'],
            categories: List<String>.from(video['categories']),
            views: video['views'],
            likes: video['likes'],
            title: video['title'],
            description: video['desc'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailPage(),
                ),
              );
            },
          ),
        ),
        if (filteredVideos.length > limit)
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyWidget(),
                  ),
                );
              },
              child: const Text(
                'Lihat Video Lainnya',
                style: TextStyle(
                  color: AppColors.primary1,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
