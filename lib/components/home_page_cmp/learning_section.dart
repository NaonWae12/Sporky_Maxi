import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/home_page_cmp/home_recommendation_card.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

class LearningSection extends StatefulWidget {
  const LearningSection({super.key});

  @override
  State<LearningSection> createState() => _LearningSectionState();
}

class _LearningSectionState extends State<LearningSection> {
  static const ApiClient _apiClient = ApiClient();
  static const String _fallbackImage = 'assets/temp_img/picky_eater.png';

  late Future<List<_HomeVideoData>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  void _loadVideos() {
    _videosFuture = _fetchVideos();
  }

  Future<List<_HomeVideoData>> _fetchVideos() async {
    final response = await _apiClient.get(
      ApiEndpoints.videoRecommendations(limit: 5, sortByLikes: true),
    );
    final data = response['data'];
    final videosNode = data is Map<String, dynamic> ? data['videos'] : null;
    final videos =
        (videosNode is List ? videosNode : const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(_mapVideo)
            .toList()
          ..sort((a, b) {
            final likesComparison = b.likes.compareTo(a.likes);
            if (likesComparison != 0) return likesComparison;
            return b.title.compareTo(a.title);
          });

    return videos;
  }

  _HomeVideoData _mapVideo(Map<String, dynamic> video) {
    final title = video['title']?.toString().trim();
    final subtitle = video['subtitle']?.toString().trim();
    final description = video['description']?.toString().trim();

    return _HomeVideoData(
      uuid: video['uuid']?.toString() ?? '',
      title: title == null || title.isEmpty ? 'Video Edukasi Sporky' : title,
      subtitle: subtitle == null || subtitle.isEmpty
          ? (description == null || description.isEmpty
                ? 'Sporky & Maxi'
                : description)
          : subtitle,
      imageUrl: _normalizeImageUrl(video['thumbnail']?.toString()),
      likes: _toInt(video['total_likes']),
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
    return FutureBuilder<List<_HomeVideoData>>(
      future: _videosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeletonRow();
        }

        if (snapshot.hasError) {
          return _buildRetryState('Gagal memuat video. Coba lagi');
        }

        final videos = snapshot.data ?? [];
        if (videos.isEmpty) {
          return _buildEmptyState('Belum ada rekomendasi video');
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: videos.map((video) {
                return HomeRecommendationCard(
                  title: video.title,
                  subtitle: video.subtitle,
                  imageUrl: video.imageUrl,
                  likes: video.likes,
                  icon: Icons.play_arrow_rounded,
                  placeholderLabel: 'Video',
                  onTap: () {
                    if (video.uuid.isEmpty) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(videoUuid: video.uuid),
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
              height: 170,
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
          onPressed: () => setState(_loadVideos),
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

class _HomeVideoData {
  final String uuid;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int likes;

  const _HomeVideoData({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.likes,
  });
}
