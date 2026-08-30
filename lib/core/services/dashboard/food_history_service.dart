import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/components/dashboard/food_history_model.dart';

class FoodHistoryService {
  const FoodHistoryService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<DailyNutritionSummary>> getDailyNutritionHistory({
    required String childUuid,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final endDate = dateTo ?? DateTime.now();
    final startDate = dateFrom ?? endDate.subtract(const Duration(days: 6));

    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.childFoodHistory(childUuid), {
        'date_from': _formatDate(startDate),
        'date_to': _formatDate(endDate),
        'per_page': '100',
      }),
    );

    final data = ApiParser.map(response['data']);
    return ApiParser.mapList(
      data['daily_totals'],
    ).map(DailyNutritionSummary.fromJson).toList().reversed.toList();
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _withQuery(String url, Map<String, String> params) {
    final uri = Uri.parse(url);
    return uri.replace(queryParameters: params).toString();
  }
}
