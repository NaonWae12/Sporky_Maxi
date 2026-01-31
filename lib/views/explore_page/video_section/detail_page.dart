import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/video_cmp/detail_vid_cmp/top_content.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../components/explore_cmp/video_cmp/detail_vid_cmp/bottom_content.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Video",
          style: AppTextStyles.heading2SemiBold(),
        ),
      ),
      body: Column(
        children: [
          TopContent(
            // imageAsset: 'assets/images/picky_eater.png',
            categories: const ['Nutrisi Anak', 'Picky Eater'],
            likes: 54,
            views: 555,
            title: 'Picky Eater Bukan Masalah!',
            subtitle: "Sporky & Maxi",
            description:
                'Jangan panik, picky eater bisa diatasi dengan cara yang fun dan lembut! Temukan cara kreatif bikin si kecil doyan makan.',
            tags: const ['Nutrisi Anak', 'Picky Eater'],
            onTap: () {
              // aksi saat card di-tap
            },
          ),
          const BottomContent(
            title:
                "Ingin lebih paham lebih lanjut terkait Picky Eater pada Anak?",
            description:
                "Baca artikel edukatif kami atau konsultasikan langsung dengan dokter pilihan Bunda. Yuk, kenali bantu kenali  si Kecil agar tetap sehat!",
          ),
        ],
      ),
    );
  }
}
