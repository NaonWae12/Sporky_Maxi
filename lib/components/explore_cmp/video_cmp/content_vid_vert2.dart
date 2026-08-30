import 'package:flutter/material.dart';
import 'package:sporky_maxi/core/services/explore/explore_content_service.dart';
import 'package:sporky_maxi/models/api/paginated_state.dart';
import 'package:sporky_maxi/models/components/explore/explore_content_model.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

import '../../globals/card/video_card_item.dart';

class ContentVidVert2 extends StatefulWidget {
  final String searchQuery;
  final Map<String, dynamic>? selectedTopic;

  const ContentVidVert2({super.key, this.searchQuery = '', this.selectedTopic});

  @override
  State<ContentVidVert2> createState() => _ContentVidVert2State();
}

class _ContentVidVert2State extends State<ContentVidVert2> {
  static const ExploreContentService _service = ExploreContentService();
  static const int _perPage = 20;

  final ScrollController _scrollController = ScrollController();
  PaginatedState<ExploreVideoContent> _state = const PaginatedState(
    items: [],
    currentPage: 0,
    lastPage: 1,
  );
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void didUpdateWidget(covariant ContentVidVert2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTopic?['id'] != widget.selectedTopic?['id'] ||
        oldWidget.searchQuery != widget.searchQuery) {
      _loadInitial();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter > 240) return;
    if (!_state.hasMore || _state.isLoadingMore) return;
    _loadMore();
  }

  Future<ExploreContentPage<ExploreVideoContent>> _fetchPage(int page) {
    final query = widget.searchQuery.trim();
    final topicId = widget.selectedTopic?['id'] as int?;

    if (query.isNotEmpty) {
      return _service.searchVideos(
        query: query,
        page: page,
        perPage: _perPage,
        filterTopicId: topicId,
      );
    }

    return _service.getVideos(
      page: page,
      perPage: _perPage,
      filterTopicId: topicId,
    );
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      final page = await _fetchPage(1);
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: page.items,
          currentPage: page.currentPage,
          lastPage: page.lastPage,
        );
        _isInitialLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(error: error);
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _state = _state.copyWith(isLoadingMore: true);
    });

    try {
      final page = await _fetchPage(_state.currentPage + 1);
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: [..._state.items, ...page.items],
          currentPage: page.currentPage,
          lastPage: page.lastPage,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(isLoadingMore: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_state.error != null) {
      return SizedBox(
        height: 220,
        child: Center(
          child: TextButton(
            onPressed: _loadInitial,
            child: const Text('Gagal memuat video. Coba lagi'),
          ),
        ),
      );
    }

    if (_state.items.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text(
            widget.searchQuery.trim().isEmpty
                ? 'Belum ada video'
                : 'Tidak ada video yang cocok',
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _state.items.length + (_state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _state.items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final video = _state.items[index];
        return VideoCardItem(
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
                      builder: (context) => DetailPage(videoUuid: video.uuid),
                    ),
                  );
                },
        );
      },
    );
  }
}
