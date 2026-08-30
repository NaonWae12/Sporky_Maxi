import 'api_parser.dart';

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  const PaginationMeta.empty()
    : currentPage = 1,
      lastPage = 1,
      perPage = 0,
      total = 0;

  factory PaginationMeta.fromJson(JsonMap json) {
    return PaginationMeta(
      currentPage: ApiParser.integer(json['current_page'], 1),
      lastPage: ApiParser.integer(json['last_page'], 1),
      perPage: ApiParser.integer(json['per_page']),
      total: ApiParser.integer(json['total']),
    );
  }
}
