import 'package:flutter/material.dart';

import '../../../components/globals/card/video_card_item.dart';
import '../../../components/globals/form/search_input.dart';
import '../../../components/globals/text/text_style.dart';

class VideoFav extends StatefulWidget {
  const VideoFav({super.key});

  @override
  State<VideoFav> createState() => _VideoFavState();
}

class _VideoFavState extends State<VideoFav> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Favorit',
          style: AppTextStyles.heading2SemiBold(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            SearchInput(
                showHeartIcon: false,
                hintText: 'brokoli pasta',
                controller: searchController,
                onHeartPressed: () {}),
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
      ),
    );
  }
}
