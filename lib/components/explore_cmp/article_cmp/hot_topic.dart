import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/cmp_article.dart';

import '../../../views/explore_page/article_section/detail_article.dart';

class HotTopic extends StatefulWidget {
  const HotTopic({super.key});

  @override
  State<HotTopic> createState() => _HotTopicState();
}

class _HotTopicState extends State<HotTopic> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> articles = [
      CmpArticle(
        imageAsset: "assets/temp_img/good_topic.png",
        categories: const ['Nutrisi Anak', 'Picky Eater'],
        views: 1200,
        likes: 567,
        title: "Kebiasaan Baik? Bisa Dilatih!",
        doctor: "dr.Clara",
        description:
            'Mulai dari ucap “terima kasih” sampai merapikan mainan — yuk bantu anak belajar lewat cara yang menyenangkan dan konsisten!',
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailArticle(),
              ));
        },
      ),
      const SizedBox(height: 8),
      CmpArticle(
        categories: const ['Nutrisi Anak', 'Picky Eater'],
        views: 1200,
        likes: 567,
        title: "Kebiasaan Baik? Bisa Dilatih! (2)",
        doctor: "dr.Clara",
        description:
            'Tips lainnya untuk membantu anak lebih disiplin dengan cara yang menyenangkan!',
        onTap: () {
          debugPrint('Article 2 tapped');
        },
      ),
      const SizedBox(height: 8),
      CmpArticle(
        categories: const ['Nutrisi Anak', 'Picky Eater'],
        views: 1200,
        likes: 567,
        title: "Kebiasaan Baik? Bisa Dilatih! (3)",
        doctor: "dr.Clara",
        description:
            'Bagaimana memotivasi anak untuk punya kebiasaan positif di rumah.',
        onTap: () {
          debugPrint('Article 3 tapped');
        },
      ),
      const SizedBox(height: 8),
      CmpArticle(
        categories: const ['Nutrisi Anak', 'Picky Eater'],
        views: 1200,
        likes: 567,
        title: "Kebiasaan Baik? Bisa Dilatih! (4)",
        doctor: "dr.Clara",
        description:
            'Strategi untuk orang tua agar anak lebih kooperatif dan disiplin.',
        onTap: () {
          debugPrint('Article 4 tapped');
        },
      ),
    ];
    // Hitung jumlah artikel saja (tanpa SizedBox)
    final int totalArticles = articles.whereType<CmpArticle>().length;
    final bool showButton = totalArticles > 3;

    // Ambil hanya 3 artikel pertama (dan widget lain yang nyertainya)
    List<Widget> displayedArticles;
    if (_showAll || !showButton) {
      displayedArticles = articles;
    } else {
      displayedArticles = [];
      int articleCount = 0;
      for (var widget in articles) {
        if (widget is CmpArticle) {
          articleCount++;
          if (articleCount > 3) break;
        }
        displayedArticles.add(widget);
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...displayedArticles,
          if (showButton)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAll = !_showAll;
                  });
                },
                child: Text(_showAll ? 'Show Less' : 'Show More'),
              ),
            ),
        ],
      ),
    );
  }
}
