import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/api/pagination_meta.dart';

class SavedContent {
  final String uuid;
  final String contentType;
  final int contentId;
  final SavedContentDetail? content;
  final DateTime? savedAt;

  const SavedContent({
    required this.uuid,
    required this.contentType,
    required this.contentId,
    required this.content,
    required this.savedAt,
  });

  bool get isArticle {
    final type = contentType.toLowerCase();
    return type == 'article' || type.endsWith('\\article');
  }

  bool get isVideo {
    final type = contentType.toLowerCase();
    return type == 'video' || type.endsWith('\\video');
  }

  factory SavedContent.fromJson(JsonMap json) {
    final contentJson = ApiParser.map(json['content']);
    return SavedContent(
      uuid: ApiParser.string(json['uuid']),
      contentType: ApiParser.string(json['content_type']),
      contentId: ApiParser.integer(json['content_id']),
      content: contentJson.isEmpty
          ? null
          : SavedContentDetail.fromJson(contentJson),
      savedAt: ApiParser.dateTime(json['saved_at']),
    );
  }
}

class SavedContentDetail {
  final String uuid;
  final String title;
  final String subtitle;
  final String thumbnail;
  final String description;
  final String authorName;
  final List<String> tags;
  final int totalViews;
  final int totalLikes;
  final String youtubeLink;

  const SavedContentDetail({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.description,
    required this.authorName,
    required this.tags,
    required this.totalViews,
    required this.totalLikes,
    required this.youtubeLink,
  });

  factory SavedContentDetail.fromJson(JsonMap json) {
    final author = ApiParser.map(json['author']);
    return SavedContentDetail(
      uuid: ApiParser.string(json['uuid']),
      title: ApiParser.string(json['title']),
      subtitle: ApiParser.string(json['subtitle']),
      thumbnail: ApiParser.string(json['thumbnail']),
      description: ApiParser.string(json['description']),
      authorName: ApiParser.string(author['name'], 'Sporky & Maxi'),
      tags: _toStringList(json['tags']).isNotEmpty
          ? _toStringList(json['tags'])
          : _toStringList(json['filter_topic']),
      totalViews: ApiParser.integer(json['total_views']),
      totalLikes: ApiParser.integer(json['total_likes']),
      youtubeLink: ApiParser.string(json['youtube_link']),
    );
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return <String>[];
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class SavedContentListResponse {
  final List<SavedContent> savedContents;
  final PaginationMeta pagination;

  const SavedContentListResponse({
    required this.savedContents,
    required this.pagination,
  });

  factory SavedContentListResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return SavedContentListResponse(
      savedContents: ApiParser.mapList(
        data['saved_contents'],
      ).map(SavedContent.fromJson).toList(),
      pagination: PaginationMeta.fromJson(ApiParser.map(data['pagination'])),
    );
  }
}
