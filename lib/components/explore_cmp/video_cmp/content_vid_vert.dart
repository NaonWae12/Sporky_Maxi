import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

import '../../globals/card/video_card_item.dart';

class ContentVidVert extends StatelessWidget {
  const ContentVidVert({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          VideoCardItem(
            // imageAsset: 'assets/temp_img/sample_video.jpg', // contoh dummy
            categories: const ['Nutrisi Anak', 'Picky Eater'],
            views: 1200,
            likes: 567,
            title: 'Picky Eater Bukan Masalah!',
            description:
                'Jangan panik, picky eater bisa diatasi dengan cara fun dan lembut!',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailPage(),
                  ));
            },
          ),
          VideoCardItem(
            // imageAsset: 'assets/temp_img/sample_video.jpg', // contoh dummy
            categories: const ['Nutrisi Anak', 'Picky Eater'],
            views: 1200,
            likes: 567,
            title: 'Picky Eater Bukan Masalah!',
            description:
                'Jangan panik, picky eater bisa diatasi dengan cara fun dan lembut!',
            onTap: () {
              // aksi saat diklik
            },
          ),
        ],
      ),
    );
  }
}
