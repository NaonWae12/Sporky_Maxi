import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/cmp_article.dart';
import 'package:sporky_maxi/core/services/explore/explore_content_service.dart';
import 'package:sporky_maxi/models/api/paginated_state.dart';
import 'package:sporky_maxi/models/components/explore/explore_content_model.dart';
import 'package:sporky_maxi/views/explore_page/article_section/detail_article.dart';

class MoreArticleCmp extends StatefulWidget {
  final String searchQuery;
  final int? selectedTopicId;

  const MoreArticleCmp({
    super.key,
    this.searchQuery = '',
    this.selectedTopicId,
  });

  @override
  State<MoreArticleCmp> createState() => _MoreArticleCmpState();
}

class _MoreArticleCmpState extends State<MoreArticleCmp> {
  static const ExploreContentService _service = ExploreContentService();
  static const int _perPage = 20;

  final ScrollController _scrollController = ScrollController();
  PaginatedState<ExploreArticleContent> _state = const PaginatedState(
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
  void didUpdateWidget(covariant MoreArticleCmp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedTopicId != widget.selectedTopicId) {
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

  Future<ExploreContentPage<ExploreArticleContent>> _fetchPage(int page) {
    final query = widget.searchQuery.trim();
    if (query.isNotEmpty) {
      return _service.searchArticles(
        query: query,
        page: page,
        perPage: _perPage,
        filterTopicId: widget.selectedTopicId,
      );
    }

    return _service.getArticles(
      page: page,
      perPage: _perPage,
      filterTopicId: widget.selectedTopicId,
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
            child: const Text('Gagal memuat artikel. Coba lagi'),
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
                ? 'Belum ada artikel'
                : 'Tidak ada artikel yang cocok',
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

        final article = _state.items[index];
        return CmpArticle(
          imageAsset: article.imageUrl(),
          categories: article.categories,
          views: article.totalViews,
          likes: article.totalLikes,
          title: article.title,
          doctor: article.authorName,
          description: article.subtitle,
          onTap: article.uuid.isEmpty
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailArticle(articleUuid: article.uuid),
                    ),
                  );
                },
        );
      },
    );
  }
}
