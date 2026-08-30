import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/api/pagination_meta.dart';

class AppNotification {
  final String uuid;
  final String title;
  final String type;
  final bool isRead;
  final DateTime? createdAt;

  const AppNotification({
    required this.uuid,
    required this.title,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(JsonMap json) {
    return AppNotification(
      uuid: ApiParser.string(json['uuid']),
      title: ApiParser.string(json['title']),
      type: ApiParser.string(json['type']),
      isRead: ApiParser.boolean(json['is_read']),
      createdAt: ApiParser.dateTime(json['created_at']),
    );
  }
}

class AppNotificationListResponse {
  final List<AppNotification> notifications;
  final PaginationMeta pagination;

  const AppNotificationListResponse({
    required this.notifications,
    required this.pagination,
  });

  factory AppNotificationListResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return AppNotificationListResponse(
      notifications: ApiParser.mapList(
        data['notifications'],
      ).map(AppNotification.fromJson).toList(),
      pagination: PaginationMeta.fromJson(ApiParser.map(data['pagination'])),
    );
  }
}
