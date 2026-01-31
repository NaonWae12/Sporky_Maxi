import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/detail_article/teks_article_cmp.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/detail_article/top_content.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/detail_article/bottom_content.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class DetailArticle extends StatelessWidget {
  const DetailArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Artikel',
          style: AppTextStyles.heading2SemiBold(),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            TopContent(
                doctorImage: 'assets/logo_dummy.png',
                doctor: "Dr.Palomina",
                title: "Bersin Terus? Hati-Hati, Bisa Jadi Tanda Alergi!",
                views: 1.2,
                likes: 200,
                categories: ['Alergi']),
            TeksArticleCmp(),
            BottomContent(
                title: "Ingin lebih paham lebih lanjut terkait Alergi Anak?",
                description:
                    "Tonton video edukatif kami atau konsultasikan langsung dengan dokter pilihan Bunda. Yuk, kenali tanda alergi sejak dini agar si Kecil tetap nyaman dan sehat!")
          ],
        ),
      ),
    );
  }
}
