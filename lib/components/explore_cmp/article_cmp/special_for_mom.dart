import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/cmp_article.dart';

import '../../../views/explore_page/article_section/more_page_aricle.dart';
import '../../globals/colors/colors.dart';

class SpecialForMom extends StatelessWidget {
  final String searchQuery;

  const SpecialForMom({
    super.key,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final articles = <_ArticleData>[
      const _ArticleData(
        imageAsset: 'assets/temp_img/good_topic.png',
        categories: ['Nutrisi Anak', 'Picky Eater'],
        views: 1200,
        likes: 567,
        title: 'Kebiasaan Baik? Bisa Dilatih!',
        doctor: 'dr.Clara',
        description: 'Mulai dari ucap “terima kasih” sampai merapikan mainan...',
      ),
      const _ArticleData(
        categories: ['Nutrisi Anak', 'Picky Eater'],
        views: 1200,
        likes: 567,
        title: 'Kebiasaan Baik? Bisa Dilatih! (2)',
        doctor: 'dr.Clara',
        description: 'Tips lainnya...',
      ),
      const _ArticleData(
        categories: ['Nutrisi Anak', 'Picky Eater'],
        views: 1200,
        likes: 567,
        title: 'Kebiasaan Baik? Bisa Dilatih! (3)',
        doctor: 'dr.Clara',
        description: 'Bagaimana memotivasi anak...',
      ),
    ];

    final query = searchQuery.trim().toLowerCase();
    final filteredArticles = query.isEmpty
        ? articles
        : articles.where((article) {
            final title = article.title.toLowerCase();
            final description = article.description.toLowerCase();
            return title.contains(query) || description.contains(query);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (filteredArticles.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Tidak ada artikel yang cocok',
              textAlign: TextAlign.center,
            ),
          ),
        ...filteredArticles.map(
          (article) => Column(
            children: [
              CmpArticle(
                imageAsset: article.imageAsset,
                categories: article.categories,
                views: article.views,
                likes: article.likes,
                title: article.title,
                doctor: article.doctor,
                description: article.description,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MoreArticlePage(),
                ),
              );
            },
            child: const Text(
              'Lihat Artikel Lainnya',
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

class _ArticleData {
  final String? imageAsset;
  final List<String> categories;
  final int views;
  final int likes;
  final String title;
  final String doctor;
  final String description;

  const _ArticleData({
    this.imageAsset,
    required this.categories,
    required this.views,
    required this.likes,
    required this.title,
    required this.doctor,
    required this.description,
  });
}
