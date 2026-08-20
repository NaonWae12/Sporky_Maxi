import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

import '../../../core/utils/secure_storage_service.dart';
import '../../globals/card/video_card_item.dart';
import '../../globals/constants/api_endpoints.dart';

class ContentVidVert2 extends StatefulWidget {
  final String searchQuery;
  /// Topic object yang dipilih dari filter chip. Null = Semua.
  final Map<String, dynamic>? selectedTopic;

  const ContentVidVert2({
    super.key,
    this.searchQuery = '',
    this.selectedTopic,
  });

  @override
  State<ContentVidVert2> createState() => _ContentVidVert2State();
}

class _ContentVidVert2State extends State<ContentVidVert2> {
  static const String _fallbackMediaUrl = 'assets/temp_img/picky_eater.png';
  static const String _fallbackTitle = 'Video Edukasi Sporky';
  static const String _fallbackDescription =
      'Konten video edukasi untuk tumbuh kembang si kecil.';
  static const List<String> _fallbackCategories = ['Video Edukasi'];

  static const Map<int, List<String>> _topicIdToSlugs = {
    1: ['mpasi'],
    2: ['tumbuh_kembang_anak', 'tumbuh_kembang'],
    3: ['nutrisi_gizi_anak', 'aktivitas_nutrisi_anak', 'nutrisi', 'gizi'],
    4: ['parenting_lifestyle', 'parenting'],
    6: ['kesehatan_mental_ibu_anak', 'kesehatan_mental', 'mental'],
    7: ['perencanaan_keuangan_keluarga', 'keuangan'],
  };

  late Future<List<_VideoCardData>> _videosFuture;

  @override
  void didUpdateWidget(covariant ContentVidVert2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTopic?['id'] != widget.selectedTopic?['id']) {
      _loadVideos();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  void _loadVideos() {
    _videosFuture = _fetchVideos();
  }

  Future<List<_VideoCardData>> _fetchVideos() async {
    final token = await SecureStorageService.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = token;
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.videos()),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data video (${response.statusCode})');
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
    final uuid = video['uuid']?.toString();
    final title = (video['title'] as String?)?.trim();
    final subtitle = (video['subtitle'] as String?)?.trim();
    final description = (video['description'] as String?)?.trim();
    
    final tags = (video['tags'] is List ? video['tags'] as List : const [])
        .map((tag) => tag.toString().trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
        
    final filterTopics = (video['filter_topic'] is List ? video['filter_topic'] as List : const [])
        .map((t) => t.toString().trim().toLowerCase())
        .toList();

    return _VideoCardData(
      uuid: (uuid == null || uuid.isEmpty) ? '' : uuid,
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
      filterTopics: filterTopics,
    );
  }

  String _normalizeMediaUrl(String? mediaUrl) {
    final url = mediaUrl?.trim() ?? '';
    if (url.isEmpty) return _fallbackMediaUrl;

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

  List<String> _getTopicSearchTerms(Map<String, dynamic> topic) {
    final id = topic['id'] as int?;
    final name = (topic['name']?.toString() ?? '').toLowerCase();
    
    final List<String> terms = [];
    if (id != null && _topicIdToSlugs.containsKey(id)) {
      terms.addAll(_topicIdToSlugs[id]!);
    }
    
    // Normalisasi string name menjadi slug & pecahan kata
    final cleanName = name
        .replaceAll('&', '')
        .replaceAll('dan', '')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim();
        
    final slug = cleanName.replaceAll(RegExp(r'\s+'), '_');
    if (slug.isNotEmpty) {
      terms.add(slug);
    }
    
    // Pecah kata-kata penting saja (abaikan preposisi/kata umum)
    final List<String> commonWords = ['dan', 'yg', 'anak', 'ibu', 'untuk', 'dengan'];
    final words = cleanName
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2 && !commonWords.contains(w));
        
    terms.addAll(words);
    
    return terms.toSet().toList();
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
            height: 220,
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(_loadVideos);
                },
                child: const Text('Gagal memuat video. Coba lagi'),
              ),
            ),
          );
        }

        var videos = snapshot.data ?? [];

        // Filter berdasarkan topic yang dipilih (client-side)
        if (widget.selectedTopic != null && widget.selectedTopic!['id'] != null) {
          final searchTerms = _getTopicSearchTerms(widget.selectedTopic!);
          
          videos = videos.where((video) {
            // Cocokkan term ke filter_topic list dari video
            final matchesFilterTopic = video.filterTopics.any((ft) {
              return searchTerms.any((term) => ft.contains(term) || term.contains(ft));
            });
            // Cocokkan term ke categories/tags list dari video
            final matchesCategories = video.categories.any((cat) {
              final catLower = cat.toLowerCase();
              return searchTerms.any((term) => catLower.contains(term) || term.contains(catLower));
            });
            return matchesFilterTopic || matchesCategories;
          }).toList();
        }

        // Filter berdasarkan search query
        if (widget.searchQuery.isNotEmpty) {
          final query = widget.searchQuery.toLowerCase();
          videos = videos
              .where((video) =>
                  video.title.toLowerCase().contains(query) ||
                  video.description.toLowerCase().contains(query) ||
                  video.categories
                      .any((cat) => cat.toLowerCase().contains(query)))
              .toList();
        }

        if (videos.isEmpty) {
          return const SizedBox(
            height: 220,
            child: Center(child: Text('Belum ada video')),
          );
        }

        return Column(
          children: videos
              .map(
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
              )
              .toList(),
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
  final List<String> filterTopics;

  const _VideoCardData({
    required this.uuid,
    required this.mediaUrl,
    required this.categories,
    required this.views,
    required this.likes,
    required this.title,
    required this.description,
    required this.filterTopics,
  });
}
