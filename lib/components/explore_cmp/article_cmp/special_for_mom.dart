import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/cmp_article.dart';

class SpecialForMom extends StatefulWidget {
  const SpecialForMom({super.key});

  @override
  State<SpecialForMom> createState() => _SpecialForMomState();
}

class _SpecialForMomState extends State<SpecialForMom> {
  bool _showAll = false;

  // Data artikel lu
  final List<Widget> _articles = [
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
    const SizedBox(height: 8),
    const CmpArticle(
      categories: ['Nutrisi Anak', 'Picky Eater'],
      views: 1200,
      likes: 567,
      title: "Kebiasaan Baik? Bisa Dilatih! (2)",
      doctor: "dr.Clara",
      description:
          'Tips lainnya untuk membantu anak lebih disiplin dengan cara yang menyenangkan!',
    ),
    const SizedBox(height: 8),
    const CmpArticle(
      categories: ['Nutrisi Anak', 'Picky Eater'],
      views: 1200,
      likes: 567,
      title: "Kebiasaan Baik? Bisa Dilatih! (3)",
      doctor: "dr.Clara",
      description:
          'Bagaimana memotivasi anak untuk punya kebiasaan positif di rumah.',
    ),
    const SizedBox(height: 8),
    const CmpArticle(
      categories: ['Nutrisi Anak', 'Picky Eater'],
      views: 1200,
      likes: 567,
      title: "Kebiasaan Baik? Bisa Dilatih! (4)",
      doctor: "dr.Clara",
      description:
          'Strategi untuk orang tua agar anak lebih kooperatif dan disiplin.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Hitung jumlah artikel saja (tanpa SizedBox)
    final int totalArticles = _articles.whereType<CmpArticle>().length;
    final bool showButton = totalArticles > 3;

    // Ambil hanya 3 artikel pertama (dan widget lain yang nyertainya)
    List<Widget> displayedArticles;
    if (_showAll || !showButton) {
      displayedArticles = _articles;
    } else {
      displayedArticles = [];
      int articleCount = 0;
      for (var widget in _articles) {
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
