import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/cmp_article.dart';
import 'package:sporky_maxi/core/services/explore/explore_content_service.dart';
import 'package:sporky_maxi/models/components/explore/explore_content_model.dart';
import 'package:sporky_maxi/views/explore_page/article_section/detail_article.dart';
import 'package:sporky_maxi/views/explore_page/article_section/more_page_aricle.dart';

class HotTopic extends StatefulWidget {
  final String searchQuery;
  final int limit;

  const HotTopic({super.key, this.searchQuery = '', this.limit = 5});

  @override
  State<HotTopic> createState() => _HotTopicState();
}

class _HotTopicState extends State<HotTopic> {
  static const ExploreContentService _service = ExploreContentService();

  late Future<List<ExploreArticleContent>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void didUpdateWidget(covariant HotTopic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.limit != widget.limit ||
        oldWidget.searchQuery != widget.searchQuery) {
      _loadArticles();
    }
  }

  void _loadArticles() {
    _articlesFuture = _fetchArticles();
  }

  Future<List<ExploreArticleContent>> _fetchArticles() async {
    final query = widget.searchQuery.trim();
    if (query.isNotEmpty) {
      return (await _service.searchArticles(query: query)).items;
    }

    return _service.getArticleRecommendations(limit: widget.limit);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExploreArticleContent>>(
      future: _articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 150,
            child: Center(
              child: TextButton(
                onPressed: () => setState(_loadArticles),
                child: const Text('Gagal memuat artikel. Coba lagi'),
              ),
            ),
          );
        }

        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Belum ada rekomendasi artikel')),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...articles.take(widget.limit).map((article) {
              return Column(
                children: [
                  CmpArticle(
                    imageAsset: article.imageUrl(),
                    categories: article.categories,
                    views: article.totalViews,
                    likes: article.totalLikes,
                    title: article.title,
                    doctor: article.authorName,
                    description: article.subtitle,
                    onTap: article.uuid.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailArticle(articleUuid: article.uuid),
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoreArticlePage(
                        initialSearchQuery: widget.searchQuery,
                      ),
                    ),
                  );
                },
                child: const Text('Lihat Artikel Lainnya'),
              ),
            ),
          ],
        );
      },
    );
  }
}
