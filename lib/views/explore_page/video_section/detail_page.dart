import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/explore_cmp/video_cmp/detail_vid_cmp/top_content.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../components/globals/video/global_youtube_player.dart';

import '../../../components/explore_cmp/video_cmp/detail_vid_cmp/bottom_content.dart';

class DetailPage extends StatefulWidget {
  final String? videoUuid;

  const DetailPage({super.key, this.videoUuid});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static const String _fallbackYoutubeUrl =
      'https://www.youtube.com/watch?v=zLxv8sqbpyU';
  static const String _fallbackMediaUrl = 'assets/temp_img/picky_eater.png';
  static const String _fallbackTitle = 'Video Edukasi Sporky';
  static const String _fallbackSubtitle = 'Sporky & Maxi';
  static const String _fallbackDescription =
      'Konten video edukasi untuk tumbuh kembang si kecil.';
  static const List<String> _fallbackTags = ['Video Edukasi'];

  late Future<_VideoDetailData> _videoFuture;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _videoFuture = _fetchVideo();
  }

  YoutubePlayerController? _youtubeController;

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<_VideoDetailData> _fetchVideo() async {
    final videoUuid = widget.videoUuid?.trim();
    if (videoUuid == null || videoUuid.isEmpty) {
      return _fallbackVideoData();
    }

    final token = await SecureStorageService.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = token;
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.videoDetail(videoUuid)),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail video (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final videoNode = body['data'];
    if (videoNode is! Map<String, dynamic>) {
      throw Exception('Format respons detail video tidak valid');
    }

    return _mapVideoDetailData(videoNode);
  }

  _VideoDetailData _fallbackVideoData() {
    return const _VideoDetailData(
      uuid: '',
      title: _fallbackTitle,
      subtitle: _fallbackSubtitle,
      description: _fallbackDescription,
      mediaUrl: _fallbackMediaUrl,
      youtubeLink: '',
      views: 0,
      likes: 0,
      tags: _fallbackTags,
    );
  }

  _VideoDetailData _mapVideoDetailData(Map<String, dynamic> video) {
    final title = (video['title'] as String?)?.trim();
    final subtitle = (video['subtitle'] as String?)?.trim();
    final description = (video['description'] as String?)?.trim();
    final youtubeLink = (video['youtube_link'] as String?)?.trim();
    final tags = (video['tags'] is List ? video['tags'] as List : const [])
        .map((tag) => tag.toString().trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final finalYoutubeLink = _resolveYoutubeLink(youtubeLink);

    return _VideoDetailData(
      uuid: video['uuid']?.toString() ?? '',
      title: (title == null || title.isEmpty) ? _fallbackTitle : title,
      subtitle:
          (subtitle == null || subtitle.isEmpty) ? _fallbackSubtitle : subtitle,
      description: (description == null || description.isEmpty)
          ? _fallbackDescription
          : description,
      mediaUrl: _normalizeMediaUrl(video['thumbnail'] as String?),
      youtubeLink: finalYoutubeLink,
      views: _toInt(video['total_views']),
      likes: _toInt(video['total_likes']),
      tags: tags.isNotEmpty ? tags : _fallbackTags,
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

  String _resolveYoutubeLink(String? rawLink) {
    final cleaned = rawLink?.trim() ?? '';
    if (_containsYoutubeVideoId(cleaned)) {
      return cleaned;
    }

    // Fallback link dummy hanya untuk development.
    return kDebugMode ? _fallbackYoutubeUrl : '';
  }

  bool _containsYoutubeVideoId(String input) {
    if (input.isEmpty) {
      return false;
    }

    final normalized = input
        .replaceAll(r'\/', '/')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'''^["']|["']$'''), '')
        .trim();

    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(normalized)) {
      return true;
    }

    return RegExp(
      r'(?:v=|\/embed\/|\/shorts\/|\/live\/|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    ).hasMatch(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_VideoDetailData>(
      future: _videoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScaffold();
        }

        if (snapshot.hasError) {
          return _buildErrorScaffold();
        }

        final video = snapshot.data ?? _fallbackVideoData();
        final videoId = GlobalYoutubePlayer.extractId(video.youtubeLink);

        // Controller TIDAK dibuat langsung di sini.
        // TopContent akan menampilkan thumbnail dulu,
        // lalu baru init player saat user tap play.

        final effectiveAspectRatio =
            video.youtubeLink.contains('/shorts/') ? 9 / 16 : 16 / 9;

        return GlobalYoutubeScaffold(
          controller: _youtubeController,
          aspectRatio: effectiveAspectRatio,
          builder: (context, playerWidget) {
            return _buildMainScaffold(context, video, playerWidget, videoId);
          },
        );
      },
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Video", style: AppTextStyles.heading2SemiBold()),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Video", style: AppTextStyles.heading2SemiBold()),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => setState(_loadVideo),
          child: const Text('Gagal memuat detail video. Coba lagi'),
        ),
      ),
    );
  }

  Widget _buildMainScaffold(
      BuildContext context, _VideoDetailData video, Widget? playerWidget, String? videoId) {
    final isFullScreen = _youtubeController?.value.isFullScreen ?? false;

    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              title: Text(
                "Detail Video",
                style: AppTextStyles.heading2SemiBold(),
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopContent(
              imageAsset: video.mediaUrl,
              youtubeLink: video.youtubeLink,
              categories: video.tags,
              likes: video.likes,
              views: video.views,
              title: video.title,
              subtitle: video.subtitle,
              description: video.description,
              tags: video.tags,
              externalController: _youtubeController,
              externalPlayer: _youtubeController == null ? null : playerWidget,
              onPlay: () {
                if (videoId != null && _youtubeController == null) {
                  setState(() {
                    _youtubeController = YoutubePlayerController(
                      initialVideoId: videoId,
                      flags: const YoutubePlayerFlags(
                        autoPlay: true,
                        mute: false,
                        disableDragSeek: false,
                        useHybridComposition: true,
                      ),
                    );
                  });
                }
              },
            ),
            const BottomContent(
              title:
                  "Ingin lebih paham lebih lanjut terkait Picky Eater pada Anak?",
              description:
                  "Baca artikel edukatif kami atau konsultasikan langsung dengan dokter pilihan Bunda. Yuk, kenali bantu kenali si Kecil agar tetap sehat!",
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoDetailData {
  final String uuid;
  final String title;
  final String subtitle;
  final String description;
  final String mediaUrl;
  final String youtubeLink;
  final int views;
  final int likes;
  final List<String> tags;

  const _VideoDetailData({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.mediaUrl,
    required this.youtubeLink,
    required this.views,
    required this.likes,
    required this.tags,
  });
}
