import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';

class ExploreArticleContent {
  final String uuid;
  final String title;
  final String subtitle;
  final String thumbnail;
  final String authorName;
  final List<String> categories;
  final int totalViews;
  final int totalLikes;

  const ExploreArticleContent({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.authorName,
    required this.categories,
    required this.totalViews,
    required this.totalLikes,
  });

  factory ExploreArticleContent.fromJson(JsonMap json) {
    final author = ApiParser.map(json['author']);
    final tags = _stringList(json['tags']);

    return ExploreArticleContent(
      uuid: ApiParser.string(json['uuid']),
      title: ApiParser.string(json['title'], 'Artikel Edukasi Sporky'),
      subtitle: ApiParser.string(
        json['subtitle'],
        'Artikel edukasi seputar tumbuh kembang si kecil.',
      ),
      thumbnail: ApiParser.string(json['thumbnail']),
      authorName: ApiParser.string(author['name'], 'Tim Sporky'),
      categories: tags.isEmpty ? const ['Artikel Edukasi'] : tags,
      totalViews: ApiParser.integer(json['total_views']),
      totalLikes: ApiParser.integer(json['total_likes']),
    );
  }

  String imageUrl({String fallback = 'assets/temp_img/good_topic.png'}) {
    return _normalizeMediaUrl(thumbnail, fallback);
  }
}

class ExploreTopic {
  final int? id;
  final String name;

  const ExploreTopic({required this.id, required this.name});

  factory ExploreTopic.fromJson(JsonMap json) {
    return ExploreTopic(
      id: json['id'] == null ? null : ApiParser.integer(json['id']),
      name: ApiParser.string(json['name'], 'Tanpa Nama'),
    );
  }
}

class ExploreContentPage<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;

  const ExploreContentPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasMore => currentPage < lastPage;
}

class ExploreVideoContent {
  final String uuid;
  final String title;
  final String subtitle;
  final String description;
  final String thumbnail;
  final String youtubeLink;
  final List<String> categories;
  final List<String> filterTopics;
  final int totalViews;
  final int totalLikes;

  const ExploreVideoContent({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.thumbnail,
    required this.youtubeLink,
    required this.categories,
    required this.filterTopics,
    required this.totalViews,
    required this.totalLikes,
  });

  factory ExploreVideoContent.fromJson(JsonMap json) {
    final tags = _stringList(json['tags']);
    final subtitle = ApiParser.string(json['subtitle']);

    return ExploreVideoContent(
      uuid: ApiParser.string(json['uuid']),
      title: ApiParser.string(json['title'], 'Video Edukasi Sporky'),
      subtitle: subtitle,
      description: ApiParser.string(
        json['description'],
        subtitle.isEmpty
            ? 'Konten video edukasi untuk tumbuh kembang si kecil.'
            : subtitle,
      ),
      thumbnail: ApiParser.string(json['thumbnail']),
      youtubeLink: ApiParser.string(json['youtube_link']),
      categories: tags.isEmpty ? const ['Video Edukasi'] : tags,
      filterTopics: _stringList(json['filter_topic']),
      totalViews: ApiParser.integer(json['total_views']),
      totalLikes: ApiParser.integer(json['total_likes']),
    );
  }

  String imageUrl({String fallback = 'assets/temp_img/picky_eater.png'}) {
    return _normalizeMediaUrl(thumbnail, fallback);
  }
}

List<String> _stringList(dynamic value) {
  if (value is! List) return <String>[];
  return value
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

String _normalizeMediaUrl(String mediaUrl, String fallback) {
  final url = mediaUrl.trim();
  if (url.isEmpty) return fallback;
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (url.startsWith('/')) return '${ApiBaseUrl.baseUrl}$url';
  return '${ApiBaseUrl.baseUrl}/$url';
}
