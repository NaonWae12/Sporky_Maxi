import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/home_page_cmp/home_recommendation_card.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/views/explore_page/article_section/detail_article.dart';

class InsightSection extends StatefulWidget {
  const InsightSection({super.key});

  @override
  State<InsightSection> createState() => _InsightSectionState();
}

class _InsightSectionState extends State<InsightSection> {
  static const ApiClient _apiClient = ApiClient();
  static const String _fallbackImage = 'assets/temp_img/picky_eater.png';

  late Future<List<_HomeArticleData>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() {
    _articlesFuture = _fetchArticles();
  }

  Future<List<_HomeArticleData>> _fetchArticles() async {
    final response = await _apiClient.get(
      ApiEndpoints.articleRecommendations(limit: 5, sortByLikes: true),
    );
    final data = response['data'];
    final articlesNode = data is Map<String, dynamic> ? data['articles'] : null;
    final articles =
        (articlesNode is List ? articlesNode : const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(_mapArticle)
            .toList()
          ..sort((a, b) {
            final likesComparison = b.likes.compareTo(a.likes);
            if (likesComparison != 0) return likesComparison;
            return b.title.compareTo(a.title);
          });

    return articles;
  }

  _HomeArticleData _mapArticle(Map<String, dynamic> article) {
    final title = article['title']?.toString().trim();
    final subtitle = article['subtitle']?.toString().trim();
    final description = article['description']?.toString().trim();

    String? authorName;
    final authorNode = article['author'];
    if (authorNode is Map) {
      authorName = authorNode['name']?.toString().trim();
    } else {
      authorName = authorNode?.toString().trim();
    }

    return _HomeArticleData(
      uuid: article['uuid']?.toString() ?? '',
      title: title == null || title.isEmpty ? 'Artikel Edukasi Sporky' : title,
      subtitle: subtitle == null || subtitle.isEmpty
          ? (authorName == null || authorName.isEmpty
                ? (description == null || description.isEmpty
                      ? 'Sporky & Maxi'
                      : description)
                : authorName)
          : subtitle,
      imageUrl: _normalizeImageUrl(article['thumbnail']?.toString()),
      likes: _toInt(article['total_likes']),
    );
  }

  String _normalizeImageUrl(String? imageUrl) {
    final url = imageUrl?.trim() ?? '';
    if (url.isEmpty) return _fallbackImage;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return '${ApiBaseUrl.baseUrl}$url';
    return '${ApiBaseUrl.baseUrl}/$url';
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_HomeArticleData>>(
      future: _articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeletonRow();
        }

        if (snapshot.hasError) {
          return _buildRetryState('Gagal memuat artikel. Coba lagi');
        }

        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return _buildEmptyState('Belum ada rekomendasi artikel');
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: articles.map((article) {
                return HomeRecommendationCard(
                  title: article.title,
                  subtitle: article.subtitle,
                  imageUrl: article.imageUrl,
                  likes: article.likes,
                  icon: Icons.menu_book_rounded,
                  placeholderLabel: 'Artikel',
                  onTap: () {
                    if (article.uuid.isEmpty) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailArticle(articleUuid: article.uuid),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: List.generate(
            3,
            (_) => Container(
              width: 226,
              height: 188,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.base4,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetryState(String message) {
    return SizedBox(
      height: 120,
      child: Center(
        child: TextButton(
          onPressed: () => setState(_loadArticles),
          child: Text(
            message,
            style: AppTextStyles.list1Regular(AppColors.primary1),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.list1Regular(AppColors.base2),
        ),
      ),
    );
  }
}

class _HomeArticleData {
  final String uuid;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int likes;

  const _HomeArticleData({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.likes,
  });
}
