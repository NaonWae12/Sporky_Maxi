import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/explore_cmp/article_cmp/cmp_article.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/views/explore_page/article_section/detail_article.dart';
import 'package:sporky_maxi/views/explore_page/article_section/more_page_aricle.dart';

class HotTopic extends StatefulWidget {
  final String searchQuery;
  final int limit;

  const HotTopic({
    super.key,
    this.searchQuery = '',
    this.limit = 5,
  });

  @override
  State<HotTopic> createState() => _HotTopicState();
}

class _HotTopicState extends State<HotTopic> {
  static const String _fallbackImage = 'assets/temp_img/good_topic.png';
  static const String _fallbackTitle = 'Artikel Edukasi Sporky';
  static const String _fallbackAuthor = 'Tim Sporky';
  static const String _fallbackDescription =
      'Artikel edukasi seputar tumbuh kembang si kecil.';
  static const List<String> _fallbackTags = ['Artikel Edukasi'];

  late Future<List<_ArticleCardData>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void didUpdateWidget(covariant HotTopic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.limit != widget.limit) {
      _loadArticles();
    }
  }

  void _loadArticles() {
    _articlesFuture = _fetchRecommendations();
  }

  Future<List<_ArticleCardData>> _fetchRecommendations() async {
    try {
      final token = await SecureStorageService.getToken();
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
      }

      final url = ApiEndpoints.articleRecommendations(limit: widget.limit);
      debugPrint('[HotTopic] GET $url');

      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint('[HotTopic] Response Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception(
            'Gagal mengambil rekomendasi artikel (${response.statusCode})');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataNode = body['data'];
      final data = dataNode is Map<String, dynamic> ? dataNode : {};
      final articlesNode = data['articles'];
      final articles = (articlesNode is List ? articlesNode : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList();

      return articles.map(_mapArticleCardData).toList();
    } catch (e, stack) {
      debugPrint('[HotTopic] Error: $e');
      debugPrint('[HotTopic] StackTrace: $stack');
      rethrow;
    }
  }

  _ArticleCardData _mapArticleCardData(Map<String, dynamic> article) {
    final uuid = article['uuid']?.toString();
    final title = article['title']?.toString().trim();
    final subtitle = article['subtitle']?.toString().trim();

    String? authorName;
    final authorNode = article['author'];
    if (authorNode is Map) {
      authorName = authorNode['name']?.toString().trim();
    } else {
      authorName = authorNode?.toString().trim();
    }

    final tags = (article['tags'] is List ? article['tags'] as List : const [])
        .map((tag) => tag.toString().trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    return _ArticleCardData(
      uuid: (uuid == null || uuid.isEmpty) ? '' : uuid,
      imageUrl: _normalizeImageUrl(article['thumbnail'] as String?),
      categories: tags.isNotEmpty ? tags : _fallbackTags,
      views: _toInt(article['total_views']),
      likes: _toInt(article['total_likes']),
      title: (title == null || title.isEmpty) ? _fallbackTitle : title,
      author: (authorName == null || authorName.isEmpty)
          ? _fallbackAuthor
          : authorName,
      description: (subtitle == null || subtitle.isEmpty)
          ? _fallbackDescription
          : subtitle,
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
    return FutureBuilder<List<_ArticleCardData>>(
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
                onPressed: () {
                  setState(_loadArticles);
                },
                child: const Text('Gagal memuat artikel. Coba lagi'),
              ),
            ),
          );
        }

        var articles = snapshot.data ?? [];

        if (widget.searchQuery.isNotEmpty) {
          final query = widget.searchQuery.trim().toLowerCase();
          articles = articles
              .where((article) =>
                  article.title.toLowerCase().contains(query) ||
                  article.description.toLowerCase().contains(query) ||
                  article.author.toLowerCase().contains(query) ||
                  article.categories
                      .any((cat) => cat.toLowerCase().contains(query)))
              .toList();
        }

        if (articles.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Belum ada rekomendasi artikel')),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...articles.map(
              (article) => Column(
                children: [
                  CmpArticle(
                    imageAsset: article.imageUrl,
                    categories: article.categories,
                    views: article.views,
                    likes: article.likes,
                    title: article.title,
                    doctor: article.author,
                    description: article.description,
                    onTap: () {
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
              ),
            ),
            const SizedBox(height: 12),
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
      },
    );
  }
}

class _ArticleCardData {
  final String uuid;
  final String imageUrl;
  final List<String> categories;
  final int views;
  final int likes;
  final String title;
  final String author;
  final String description;

  const _ArticleCardData({
    required this.uuid,
    required this.imageUrl,
    required this.categories,
    required this.views,
    required this.likes,
    required this.title,
    required this.author,
    required this.description,
  });
}
