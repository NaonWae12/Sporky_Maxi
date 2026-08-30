import 'package:sporky_maxi/models/api/api_parser.dart';

class ExpertConsultationInsight {
  final String period;
  final String? periodStart;
  final String? periodEnd;
  final int chatCount;
  final int zoomCount;
  final int totalCount;
  final Map<String, int> statusCounts;

  const ExpertConsultationInsight({
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    required this.chatCount,
    required this.zoomCount,
    required this.totalCount,
    required this.statusCounts,
  });

  factory ExpertConsultationInsight.fromJson(JsonMap json) {
    final rawStatusCounts = ApiParser.map(json['status_counts']);

    return ExpertConsultationInsight(
      period: ApiParser.string(json['period'], 'all'),
      periodStart: ApiParser.nullableString(json['period_start']),
      periodEnd: ApiParser.nullableString(json['period_end']),
      chatCount: ApiParser.integer(json['chat_count']),
      zoomCount: ApiParser.integer(json['zoom_count']),
      totalCount: ApiParser.integer(json['total_count']),
      statusCounts: rawStatusCounts.map(
        (key, value) => MapEntry(key, ApiParser.integer(value)),
      ),
    );
  }
}
