import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/components/explore/explore_content_model.dart';

class ExploreContentService {
  const ExploreContentService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<ExploreTopic>> getTopics() async {
    final response = await _apiClient.get(ApiEndpoints.topics);
    return ApiParser.mapList(
      response['data'],
    ).map(ExploreTopic.fromJson).toList();
  }

  Future<ExploreContentPage<ExploreArticleContent>> getArticles({
    int page = 1,
    int perPage = 50,
    int? filterTopicId,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.articles, {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'filter_topic': filterTopicId?.toString(),
      }),
    );
    final data = ApiParser.map(response['data']);
    final pagination = ApiParser.map(data['pagination']);
    return ExploreContentPage(
      items: _articleListFromNode(data['articles']),
      currentPage: ApiParser.integer(pagination['current_page'], 1),
      lastPage: ApiParser.integer(pagination['last_page'], 1),
    );
  }

  Future<List<ExploreArticleContent>> getArticleRecommendations({
    int limit = 5,
    bool sortByLikes = false,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.articleRecommendations(
        limit: limit,
        sortByLikes: sortByLikes,
      ),
    );
    return _articleListFromNode(ApiParser.map(response['data'])['articles']);
  }

  Future<ExploreContentPage<ExploreArticleContent>> searchArticles({
    required String query,
    int page = 1,
    int perPage = 50,
    int? filterTopicId,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.search, {
        'q': query,
        'type': 'article',
        'page': page.toString(),
        'per_page': perPage.toString(),
        'filter_topic': filterTopicId?.toString(),
      }),
    );
    final data = ApiParser.map(response['data']);
    final articlesNode = ApiParser.map(data['articles']);
    final pagination = ApiParser.map(articlesNode['pagination']);
    return ExploreContentPage(
      items: _articleListFromNode(articlesNode['items']),
      currentPage: ApiParser.integer(pagination['current_page'], 1),
      lastPage: ApiParser.integer(pagination['last_page'], 1),
    );
  }

  Future<ExploreContentPage<ExploreVideoContent>> getVideos({
    int page = 1,
    int perPage = 50,
    int? filterTopicId,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.videos(), {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'filter_topic': filterTopicId?.toString(),
      }),
    );
    final data = ApiParser.map(response['data']);
    final pagination = ApiParser.map(data['pagination']);
    return ExploreContentPage(
      items: _videoListFromNode(data['videos']),
      currentPage: ApiParser.integer(pagination['current_page'], 1),
      lastPage: ApiParser.integer(pagination['last_page'], 1),
    );
  }

  Future<List<ExploreVideoContent>> getVideoRecommendations({
    int limit = 5,
    bool sortByLikes = false,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.videoRecommendations(limit: limit, sortByLikes: sortByLikes),
    );
    return _videoListFromNode(ApiParser.map(response['data'])['videos']);
  }

  Future<ExploreContentPage<ExploreVideoContent>> searchVideos({
    required String query,
    int page = 1,
    int perPage = 50,
    int? filterTopicId,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.search, {
        'q': query,
        'type': 'video',
        'page': page.toString(),
        'per_page': perPage.toString(),
        'filter_topic': filterTopicId?.toString(),
      }),
    );
    final data = ApiParser.map(response['data']);
    final videosNode = ApiParser.map(data['videos']);
    final pagination = ApiParser.map(videosNode['pagination']);
    return ExploreContentPage(
      items: _videoListFromNode(videosNode['items']),
      currentPage: ApiParser.integer(pagination['current_page'], 1),
      lastPage: ApiParser.integer(pagination['last_page'], 1),
    );
  }

  List<ExploreArticleContent> _articleListFromNode(dynamic node) {
    return ApiParser.mapList(node).map(ExploreArticleContent.fromJson).toList();
  }

  List<ExploreVideoContent> _videoListFromNode(dynamic node) {
    return ApiParser.mapList(node).map(ExploreVideoContent.fromJson).toList();
  }

  String _withQuery(String url, Map<String, String?> params) {
    final uri = Uri.parse(url);
    final query = Map<String, String>.from(uri.queryParameters);

    for (final entry in params.entries) {
      final value = entry.value?.trim();
      if (value != null && value.isNotEmpty) {
        query[entry.key] = value;
      }
    }

    return uri.replace(queryParameters: query).toString();
  }
}
