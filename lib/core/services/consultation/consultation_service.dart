import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/components/consultation/consultation_product_model.dart';
import 'package:sporky_maxi/models/components/consultation/expert_model.dart';

class ConsultationService {
  const ConsultationService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<ExpertItem>> getExperts({
    int page = 1,
    int perPage = 100,
    String? role,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.experts, {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'role': role,
      }),
    );
    final data = ApiParser.map(response['data']);
    return ApiParser.mapList(
      data['experts'] ?? data['users'],
    ).map(ExpertItem.fromJson).toList();
  }

  Future<JsonMap> getExpertProfile(String expertUuid) {
    return _apiClient.get(ApiEndpoints.expertProfile(expertUuid));
  }

  Future<List<ConsultationProduct>> getExpertConsultationProducts(
    String expertUuid, {
    String? type,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.expertConsultationProducts(expertUuid), {
        'type': type,
      }),
    );
    return ApiParser.mapList(
      response['data'],
    ).map(ConsultationProduct.fromJson).toList();
  }

  Future<ConsultationCheckoutResponse> checkout({
    required String expertUuid,
    required String productUuid,
    required DateTime date,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.expertCheckout,
      body: {
        'expert_uuid': expertUuid,
        'product_uuid': productUuid,
        'date': date.toIso8601String(),
      },
    );
    return ConsultationCheckoutResponse.fromJson(response);
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

    return uri
        .replace(queryParameters: query.isEmpty ? null : query)
        .toString();
  }
}
