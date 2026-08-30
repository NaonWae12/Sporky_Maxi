import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/explore_cmp/article_cmp/cmp_article.dart';
import 'package:sporky_maxi/components/globals/card/video_card_item.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/form/search_input.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';
import 'package:sporky_maxi/models/api/paginated_state.dart';
import 'package:sporky_maxi/models/components/saved_content/saved_content_model.dart';
import 'package:sporky_maxi/views/explore_page/article_section/detail_article.dart';
import 'package:sporky_maxi/views/explore_page/video_section/detail_page.dart';

enum SavedContentFavoriteType { article, video }

class SavedContentFavoritesList extends StatefulWidget {
  final SavedContentFavoriteType type;

  const SavedContentFavoritesList({super.key, required this.type});

  @override
  State<SavedContentFavoritesList> createState() =>
      _SavedContentFavoritesListState();
}

class _SavedContentFavoritesListState extends State<SavedContentFavoritesList> {
  static const ApiFoundationService _service = ApiFoundationService();
  static const String _articleFallbackImage = 'assets/temp_img/good_topic.png';
  static const String _videoFallbackImage = 'assets/temp_img/picky_eater.png';
  static const int _perPage = 20;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PaginatedState<SavedContent> _state = const PaginatedState(
    items: [],
    currentPage: 0,
    lastPage: 1,
  );
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFavorites();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter > 240) return;
    if (!_state.hasMore || _state.isLoadingMore) return;
    _loadMore();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      final response = await _service.getSavedContents(
        page: 1,
        perPage: _perPage,
      );
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: response.savedContents.where(_matchesType).toList(),
          currentPage: response.pagination.currentPage,
          lastPage: response.pagination.lastPage,
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
      final response = await _service.getSavedContents(
        page: _state.currentPage + 1,
        perPage: _perPage,
      );
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: [
            ..._state.items,
            ...response.savedContents.where(_matchesType),
          ],
          currentPage: response.pagination.currentPage,
          lastPage: response.pagination.lastPage,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(isLoadingMore: false);
      });
    }
  }

  bool _matchesType(SavedContent item) {
    if (widget.type == SavedContentFavoriteType.article) {
      return item.isArticle;
    }
    return item.isVideo;
  }

  Future<void> _refreshFavorites() async {
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        SearchInput(
          showHeartIcon: false,
          hintText: widget.type == SavedContentFavoriteType.article
              ? 'Cari artikel favorit'
              : 'Cari video favorit',
          controller: _searchController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Builder(
            builder: (context) {
              if (_isInitialLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_state.error != null) {
                return _RefreshableFavoriteState(
                  onRefresh: _refreshFavorites,
                  child: TextButton(
                    onPressed: _loadFavorites,
                    child: const Text('Gagal memuat favorit. Coba lagi'),
                  ),
                );
              }

              final items = _filterBySearch(_state.items);
              if (items.isEmpty) {
                return _RefreshableFavoriteState(
                  onRefresh: _refreshFavorites,
                  child: Text(
                    _emptyMessage,
                    style: AppTextStyles.list1Regular(AppColors.base2),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshFavorites,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: items.length + (_state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = items[index];
                    return widget.type == SavedContentFavoriteType.article
                        ? _buildArticle(context, item)
                        : _buildVideo(context, item);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArticle(BuildContext context, SavedContent item) {
    final content = item.content;
    final tags = _categories(content, 'Artikel');
    return CmpArticle(
      imageAsset: _normalizeMediaUrl(content?.thumbnail, _articleFallbackImage),
      categories: tags,
      views: content?.totalViews ?? 0,
      likes: content?.totalLikes ?? 0,
      title: _displayTitle(content, 'Artikel favorit'),
      doctor: content?.authorName ?? 'Sporky & Maxi',
      description: _displayDescription(content, 'Konten artikel favorit'),
      onTap: content?.uuid.isNotEmpty == true
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailArticle(articleUuid: content!.uuid),
                ),
              );
            }
          : null,
    );
  }

  Widget _buildVideo(BuildContext context, SavedContent item) {
    final content = item.content;
    return VideoCardItem(
      mediaUrl: _normalizeMediaUrl(content?.thumbnail, _videoFallbackImage),
      categories: _categories(content, 'Video'),
      views: content?.totalViews ?? 0,
      likes: content?.totalLikes ?? 0,
      title: _displayTitle(content, 'Video favorit'),
      description: _displayDescription(content, 'Konten video favorit'),
      onTap: content?.uuid.isNotEmpty == true
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(videoUuid: content!.uuid),
                ),
              );
            }
          : null,
    );
  }

  List<SavedContent> _filterBySearch(List<SavedContent> items) {
    final keyword = _searchController.text.toLowerCase().trim();
    if (keyword.isEmpty) return items;

    return items.where((item) {
      final content = item.content;
      final searchable = [
        content?.title,
        content?.subtitle,
        content?.description,
        content?.authorName,
        ...?content?.tags,
      ].whereType<String>().join(' ').toLowerCase();

      return searchable.contains(keyword);
    }).toList();
  }

  List<String> _categories(SavedContentDetail? content, String fallback) {
    final tags = content?.tags ?? [];
    return tags.isEmpty ? [fallback] : tags;
  }

  String _displayTitle(SavedContentDetail? content, String fallback) {
    final title = content?.title.trim() ?? '';
    return title.isEmpty ? fallback : title;
  }

  String _displayDescription(SavedContentDetail? content, String fallback) {
    final description = content?.description.trim() ?? '';
    if (description.isNotEmpty) return description;
    final subtitle = content?.subtitle.trim() ?? '';
    return subtitle.isEmpty ? fallback : subtitle;
  }

  String _normalizeMediaUrl(String? mediaUrl, String fallback) {
    final url = mediaUrl?.trim() ?? '';
    if (url.isEmpty) return fallback;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return '${ApiBaseUrl.baseUrl}$url';
    return '${ApiBaseUrl.baseUrl}/$url';
  }

  String get _emptyMessage {
    final keyword = _searchController.text.trim();
    if (keyword.isNotEmpty) return 'Tidak ada favorit yang cocok';
    return widget.type == SavedContentFavoriteType.article
        ? 'Belum ada artikel favorit'
        : 'Belum ada video favorit';
  }
}

class _RefreshableFavoriteState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const _RefreshableFavoriteState({
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
