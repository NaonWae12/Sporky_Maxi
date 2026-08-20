import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

import 'more_vid_page_cmp.dart';
import '../../globals/card/video_card_item.dart';

class ShortVidContentMoreViews extends StatefulWidget {
  final int limit;
  final String searchQuery;

  const ShortVidContentMoreViews({
    super.key,
    this.limit = 5,
    this.searchQuery = '',
  });

  @override
  State<ShortVidContentMoreViews> createState() =>
      _ShortVidContentMoreViewsState();
}

class _ShortVidContentMoreViewsState extends State<ShortVidContentMoreViews> {
  static const String _fallbackMediaUrl = 'assets/temp_img/picky_eater.png';
  static const String _fallbackTitle = 'Video Edukasi Sporky';
  static const String _fallbackDescription =
      'Konten video edukasi untuk tumbuh kembang si kecil.';
  static const List<String> _fallbackCategories = ['Video Edukasi'];

  late Future<List<_VideoCardData>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  void didUpdateWidget(covariant ShortVidContentMoreViews oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.limit != widget.limit) {
      _loadVideos();
    }
  }

  void _loadVideos() {
    _videosFuture = _fetchVideos();
  }

  Future<List<_VideoCardData>> _fetchVideos() async {
    final token = await SecureStorageService.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] =
          token.startsWith('Bearer ') ? token : 'Bearer $token';
    }

    final url = ApiEndpoints.videoRecommendations(limit: widget.limit);
    debugPrint('[ShortVidContentMoreViews] GET $url');

    final response = await http.get(Uri.parse(url), headers: headers);
    debugPrint(
        '[ShortVidContentMoreViews] status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception(
          'Gagal mengambil rekomendasi video (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final dataNode = body['data'];
    final data = dataNode is Map<String, dynamic> ? dataNode : {};
    final videosNode = data['videos'];
    final videos = (videosNode is List ? videosNode : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList();

    return videos.map(_mapVideoCardData).toList();
  }

  _VideoCardData _mapVideoCardData(Map<String, dynamic> video) {
    final uuid = video['uuid']?.toString() ?? '';
    final title = (video['title'] as String?)?.trim();
    final subtitle = (video['subtitle'] as String?)?.trim();
    final description = (video['description'] as String?)?.trim();
    final tags = (video['tags'] is List ? video['tags'] as List : const [])
        .map((tag) => tag.toString().trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    return _VideoCardData(
      uuid: uuid,
      mediaUrl: _normalizeMediaUrl(video['thumbnail'] as String?),
      categories: tags.isNotEmpty ? tags : _fallbackCategories,
      views: _toInt(video['total_views']),
      likes: _toInt(video['total_likes']),
      title: (title == null || title.isEmpty) ? _fallbackTitle : title,
      description: (description == null || description.isEmpty)
          ? ((subtitle == null || subtitle.isEmpty)
              ? _fallbackDescription
              : subtitle)
          : description,
    );
  }

  String _normalizeMediaUrl(String? mediaUrl) {
    final url = mediaUrl?.trim() ?? '';
    if (url.isEmpty) return _fallbackMediaUrl;
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
    return FutureBuilder<List<_VideoCardData>>(
      future: _videosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 120,
            child: Center(
              child: TextButton(
                onPressed: () => setState(_loadVideos),
                child: const Text('Gagal memuat video. Coba lagi'),
              ),
            ),
          );
        }

        var videos = snapshot.data ?? [];

        // Filter berdasarkan search query
        if (widget.searchQuery.isNotEmpty) {
          final query = widget.searchQuery.trim().toLowerCase();
          videos = videos
              .where((video) =>
                  video.title.toLowerCase().contains(query) ||
                  video.description.toLowerCase().contains(query) ||
                  video.categories
                      .any((cat) => cat.toLowerCase().contains(query)))
              .toList();
        }

        if (videos.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: Text('Tidak ada video yang cocok')),
          );
        }

        return Column(
          children: [
            ...videos.map(
              (video) => VideoCardItem(
                mediaUrl: video.mediaUrl,
                categories: video.categories,
                views: video.views,
                likes: video.likes,
                title: video.title,
                description: video.description,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(videoUuid: video.uuid),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyWidget(),
                    ),
                  );
                },
                child: const Text(
                  'Lihat Video Lainnya',
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

class _VideoCardData {
  final String uuid;
  final String mediaUrl;
  final List<String> categories;
  final int views;
  final int likes;
  final String title;
  final String description;

  const _VideoCardData({
    required this.uuid,
    required this.mediaUrl,
    required this.categories,
    required this.views,
    required this.likes,
    required this.title,
    required this.description,
  });
}
