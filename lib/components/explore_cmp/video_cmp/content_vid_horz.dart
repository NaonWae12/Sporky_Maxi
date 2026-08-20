import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/explore_page/article_section/detail_article.dart';

import '../../globals/card/video_card_item.dart';

class ContentVidHorz extends StatelessWidget {
  const ContentVidHorz({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          VideoCardItem(
            mediaUrl: 'assets/temp_img/picky_eater.png', // contoh dummy
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
                    builder: (context) => const DetailArticle(),
                  ));
            },
          ),
          VideoCardItem(
            mediaUrl: 'assets/temp_img/picky_eater.png', // contoh dummy
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
