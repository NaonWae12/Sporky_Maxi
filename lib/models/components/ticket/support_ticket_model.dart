import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/api/pagination_meta.dart';

class SupportTicket {
  final String uuid;
  final String issue;
  final String status;
  final String? minutesOfMeeting;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SupportTicket({
    required this.uuid,
    required this.issue,
    required this.status,
    required this.minutesOfMeeting,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportTicket.fromJson(JsonMap json) {
    return SupportTicket(
      uuid: ApiParser.string(json['uuid']),
      issue: ApiParser.string(json['issue']),
      status: ApiParser.string(json['status']),
      minutesOfMeeting: ApiParser.nullableString(json['minutes_of_meeting']),
      createdAt: ApiParser.dateTime(json['created_at']),
      updatedAt: ApiParser.dateTime(json['updated_at']),
    );
  }
}

class SupportTicketListResponse {
  final List<SupportTicket> tickets;
  final PaginationMeta pagination;

  const SupportTicketListResponse({
    required this.tickets,
    required this.pagination,
  });

  factory SupportTicketListResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return SupportTicketListResponse(
      tickets: ApiParser.mapList(
        data['tickets'],
      ).map(SupportTicket.fromJson).toList(),
      pagination: PaginationMeta.fromJson(ApiParser.map(data['pagination'])),
    );
  }
}
