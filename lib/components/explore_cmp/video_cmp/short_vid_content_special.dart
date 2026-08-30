import 'package:flutter/material.dart';
import 'package:sporky_maxi/core/services/explore/explore_content_service.dart';
import 'package:sporky_maxi/models/components/explore/explore_content_model.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

import '../../globals/card/video_card_item.dart';
import 'more_vid_page_cmp.dart';

class ShortVidContentSpecial extends StatefulWidget {
  final int limit;
  final String searchQuery;

  const ShortVidContentSpecial({
    super.key,
    this.limit = 1,
    this.searchQuery = '',
  });

  @override
  State<ShortVidContentSpecial> createState() => _ShortVidContentSpecialState();
}

class _ShortVidContentSpecialState extends State<ShortVidContentSpecial> {
  static const ExploreContentService _service = ExploreContentService();

  late Future<List<ExploreVideoContent>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  void didUpdateWidget(covariant ShortVidContentSpecial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _loadVideos();
    }
  }

  void _loadVideos() {
    _videosFuture = _fetchVideos();
  }

  Future<List<ExploreVideoContent>> _fetchVideos() async {
    final query = widget.searchQuery.trim();
    if (query.isNotEmpty) {
      return (await _service.searchVideos(query: query)).items;
    }

    return _service.getVideoRecommendations(
      limit: widget.limit,
      sortByLikes: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExploreVideoContent>>(
      future: _videosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
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

        final videos = snapshot.data ?? [];
        if (videos.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Belum ada rekomendasi video')),
          );
        }

        final displayedVideos = videos.take(widget.limit).toList();

        return Column(
          children: [
            ...displayedVideos.map(
              (video) => VideoCardItem(
                mediaUrl: video.imageUrl(),
                categories: video.categories,
                views: video.totalViews,
                likes: video.totalLikes,
                title: video.title,
                description: video.description,
                onTap: video.uuid.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(videoUuid: video.uuid),
                          ),
                        );
                      },
              ),
            ),
            if (videos.length > widget.limit)
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyWidget(initialSearchQuery: widget.searchQuery),
                      ),
                    );
                  },
                  child: const Text('Lihat Video Lainnya'),
                ),
              ),
          ],
        );
      },
    );
  }
}
