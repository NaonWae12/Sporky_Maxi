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
import 'package:sporky_maxi/views/consultation/main_page_consultation.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

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
  bool _isSaved = false;
  bool _saving = false;
  int _likes = 0;

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
      headers['Authorization'] = token.startsWith('Bearer ')
          ? token
          : 'Bearer $token';
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

    final data = _mapArticleDetailData(articleNode);
    if (mounted) {
      setState(() {
        _isSaved = data.isSaved;
        _likes = data.likes;
      });
    }
    return data;
  }

  Future<void> _toggleSave(_ArticleDetailData article) async {
    if (_saving || article.uuid.isEmpty) return;

    final originalSaved = _isSaved;
    // Optimistic UI update (pola sama seperti favorit meal plan)
    setState(() {
      _isSaved = !_isSaved;
      _saving = true;
    });

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _isSaved = originalSaved;
            _saving = false;
          });
        }
        return;
      }

      final headers = <String, String>{'Accept': 'application/json'};
      headers['Authorization'] = token.startsWith('Bearer ')
          ? token
          : 'Bearer $token';

      final response = await http.post(
        Uri.parse(ApiEndpoints.articleSave(article.uuid)),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final dataNode = body['data'];
        final nowSaved = dataNode is Map ? dataNode['is_saved'] == true : false;
        final nowLikes = dataNode is Map
            ? _toInt(dataNode['total_likes'])
            : null;
        if (mounted) {
          setState(() {
            _isSaved = nowSaved;
            if (nowLikes != null) {
              _likes = nowLikes;
            }
            _saving = false;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint('[DetailArticle] save toggle error: $e');
    }

    // Revert jika API gagal
    if (mounted) {
      setState(() {
        _isSaved = originalSaved;
        _saving = false;
      });
    }
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

    final linkedVideos =
        (article['linked_videos'] is List
                ? article['linked_videos'] as List
                : const [])
            .whereType<Map>()
            .map(
              (v) => _LinkedContent(
                uuid: v['uuid']?.toString() ?? '',
                title: v['title']?.toString().trim() ?? '',
              ),
            )
            .where((v) => v.uuid.isNotEmpty)
            .toList();

    return _ArticleDetailData(
      uuid: article['uuid']?.toString() ?? '',
      title: (title == null || title.isEmpty) ? _fallbackTitle : title,
      subtitle: subtitle ?? '',
      imageUrl: _normalizeImageUrl(article['thumbnail'] as String?),
      author: (authorName == null || authorName.isEmpty)
          ? _fallbackAuthor
          : authorName,
      tags: tags.isNotEmpty ? tags : _fallbackTags,
      views: _toInt(article['total_views']),
      likes: _toInt(article['total_likes']),
      content: (content == null || content.isEmpty)
          ? _fallbackContent
          : content,
      isSaved: article['is_saved'] == true,
      linkedVideos: linkedVideos,
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
        title: Text('Detail Artikel', style: AppTextStyles.heading2SemiBold()),
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
                  likes: _likes > 0 ? _likes : article.likes,
                  categories: article.tags,
                  isFavorited: article.isSaved || _isSaved,
                  onFavoriteTap: article.uuid.isEmpty || _saving
                      ? null
                      : () => _toggleSave(article),
                ),
                TeksArticleCmp(content: article.content),
                if (article.linkedVideos.isNotEmpty)
                  ...article.linkedVideos.map((video) {
                    return BottomContent(
                      title: video.title,
                      description:
                          "Tonton video edukatif terkait dari kami, atau konsultasikan langsung dengan dokter pilihan Bunda.",
                      onPrimaryAction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(videoUuid: video.uuid),
                          ),
                        );
                      },
                      onConsultation: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainPageConsultation(),
                          ),
                        );
                      },
                    );
                  }),
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
  final bool isSaved;
  final List<_LinkedContent> linkedVideos;

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
    this.isSaved = false,
    this.linkedVideos = const [],
  });
}

class _LinkedContent {
  final String uuid;
  final String title;

  const _LinkedContent({required this.uuid, required this.title});
}
