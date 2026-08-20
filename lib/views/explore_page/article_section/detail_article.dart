import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/explore_cmp/article_cmp/detail_article/bottom_content.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/detail_article/teks_article_cmp.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/detail_article/top_content.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

class DetailArticle extends StatefulWidget {
  final String? articleUuid;

  const DetailArticle({super.key, this.articleUuid});

  @override
  State<DetailArticle> createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {
  static const String _fallbackImage = 'assets/temp_img/good_topic.png';
  static const String _fallbackTitle = 'Artikel Edukasi Sporky';
  static const String _fallbackAuthor = 'Tim Sporky';
  static const String _fallbackContent =
      'Konten artikel belum tersedia untuk ditampilkan.';
  static const List<String> _fallbackTags = ['Artikel Edukasi'];

  late Future<_ArticleDetailData> _articleFuture;

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  void _loadArticle() {
    _articleFuture = _fetchArticle();
  }

  Future<_ArticleDetailData> _fetchArticle() async {
    final articleUuid = widget.articleUuid?.trim();
    if (articleUuid == null || articleUuid.isEmpty) {
      return _fallbackArticleData();
    }

    final token = await SecureStorageService.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = token;
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.articleDetail(articleUuid)),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil detail artikel (${response.statusCode})',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final articleNode = body['data'];
    if (articleNode is! Map<String, dynamic>) {
      throw Exception('Format respons detail artikel tidak valid');
    }

    return _mapArticleDetailData(articleNode);
  }

  _ArticleDetailData _fallbackArticleData() {
    return const _ArticleDetailData(
      uuid: '',
      title: _fallbackTitle,
      subtitle: '',
      imageUrl: _fallbackImage,
      author: _fallbackAuthor,
      tags: _fallbackTags,
      views: 0,
      likes: 0,
      content: _fallbackContent,
    );
  }

  _ArticleDetailData _mapArticleDetailData(Map<String, dynamic> article) {
    final title = article['title']?.toString().trim();
    final subtitle = article['subtitle']?.toString().trim();
    final content = article['content']?.toString().trim();
    
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

    return _ArticleDetailData(
      uuid: article['uuid']?.toString() ?? '',
      title: (title == null || title.isEmpty) ? _fallbackTitle : title,
      subtitle: subtitle ?? '',
      imageUrl: _normalizeImageUrl(article['thumbnail'] as String?),
      author: (authorName == null || authorName.isEmpty) ? _fallbackAuthor : authorName,
      tags: tags.isNotEmpty ? tags : _fallbackTags,
      views: _toInt(article['total_views']),
      likes: _toInt(article['total_likes']),
      content: (content == null || content.isEmpty) ? _fallbackContent : content,
    );
  }

  String _normalizeImageUrl(String? imageUrl) {
    final url = imageUrl?.trim() ?? '';
    if (url.isEmpty) return _fallbackImage;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    if (url.startsWith('/')) {
      return "${ApiBaseUrl.baseUrl}$url";
    }

    return "${ApiBaseUrl.baseUrl}/$url";
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Artikel',
          style: AppTextStyles.heading2SemiBold(),
        ),
      ),
      body: FutureBuilder<_ArticleDetailData>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () {
                  setState(_loadArticle);
                },
                child: const Text('Gagal memuat detail artikel. Coba lagi'),
              ),
            );
          }

          final article = snapshot.data ?? _fallbackArticleData();

          return SingleChildScrollView(
            child: Column(
              children: [
                TopContent(
                  imageAsset: article.imageUrl,
                  doctor: article.author,
                  title: article.title,
                  views: article.views,
                  likes: article.likes,
                  categories: article.tags,
                ),
                TeksArticleCmp(content: article.content),
                const BottomContent(
                  title:
                      "Ingin lebih paham lebih lanjut terkait Alergi Anak?",
                  description:
                      "Tonton video edukatif kami atau konsultasikan langsung dengan dokter pilihan Bunda. Yuk, kenali tanda alergi sejak dini agar si Kecil tetap nyaman dan sehat!",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ArticleDetailData {
  final String uuid;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String author;
  final List<String> tags;
  final int views;
  final int likes;
  final String content;

  const _ArticleDetailData({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.author,
    required this.tags,
    required this.views,
    required this.likes,
    required this.content,
  });
}
