import 'package:flutter/material.dart';

import '../../../components/explore_cmp/article_cmp/cmp_article.dart';
import '../../../components/globals/form/search_input.dart';
import '../../../components/globals/text/text_style.dart';

class ArticleFav extends StatefulWidget {
  const ArticleFav({super.key});

  @override
  State<ArticleFav> createState() => _VideoFavState();
}

class _VideoFavState extends State<ArticleFav> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Artikel Favorit',
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
            const CmpArticle(
              imageAsset: "assets/temp_img/good_topic.png",
              categories: ['Nutrisi Anak', 'Picky Eater'],
              views: 1200,
              likes: 567,
              title: "Kebiasaan Baik? Bisa Dilatih!",
              doctor: "dr.Clara",
              description:
                  'Mulai dari ucap “terima kasih” sampai merapikan mainan — yuk bantu anak belajar lewat cara yang menyenangkan dan konsisten!',
            ),
            const CmpArticle(
              imageAsset: "assets/temp_img/good_topic.png",
              categories: ['Nutrisi Anak', 'Picky Eater'],
              views: 1200,
              likes: 567,
              title: "Kebiasaan Baik? Bisa Dilatih!",
              doctor: "dr.Clara",
              description:
                  'Mulai dari ucap “terima kasih” sampai merapikan mainan — yuk bantu anak belajar lewat cara yang menyenangkan dan konsisten!',
            ),
            const CmpArticle(
              imageAsset: "assets/temp_img/good_topic.png",
              categories: ['Nutrisi Anak', 'Picky Eater'],
              views: 1200,
              likes: 567,
              title: "Kebiasaan Baik? Bisa Dilatih!",
              doctor: "dr.Clara",
              description:
                  'Mulai dari ucap “terima kasih” sampai merapikan mainan — yuk bantu anak belajar lewat cara yang menyenangkan dan konsisten!',
            ),
          ],
        ),
      ),
    );
  }
}
