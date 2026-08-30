import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/components/consultation/consultation_product_model.dart';
import 'package:sporky_maxi/models/components/consultation/expert_agenda_model.dart';
import 'package:sporky_maxi/models/components/notification/app_notification_model.dart';
import 'package:sporky_maxi/models/components/payment/point_model.dart';
import 'package:sporky_maxi/models/components/payment/transaction_model.dart';
import 'package:sporky_maxi/models/components/saved_content/saved_content_model.dart';
import 'package:sporky_maxi/models/components/ticket/support_ticket_model.dart';

class ApiFoundationService {
  const ApiFoundationService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<JsonMap> getCurrentUser() {
    return _apiClient.get(ApiEndpoints.currentUser);
  }

  Future<AppNotificationListResponse> getNotifications({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.userNotifications, {
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
    );
    return AppNotificationListResponse.fromJson(response);
  }

  Future<SavedContentListResponse> getSavedContents({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.userSavedContents, {
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
    );
    return SavedContentListResponse.fromJson(response);
  }

  Future<AppTransactionListResponse> getTransactions({
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.transactions, {
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
    );
    return AppTransactionListResponse.fromJson(response);
  }

  Future<AppTransaction> getTransactionDetail(String transactionUuid) async {
    final response = await _apiClient.get(
      ApiEndpoints.transactionDetail(transactionUuid),
    );
    return AppTransaction.fromJson(ApiParser.map(response['data']));
  }

  Future<List<AppTransaction>> getTransactionsByOrderId(String orderId) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.transactions, {'per_page': '100'}),
    );
    final result = AppTransactionListResponse.fromJson(response);
    return result.transactions
        .where((transaction) => transaction.uuid == orderId)
        .toList();
  }

  Future<PointWallet> getPointWallet() async {
    final response = await _apiClient.get(ApiEndpoints.pointWallet);
    return PointWallet.fromJson(response);
  }

  Future<PointHistoryResponse> getPointHistory({
    String? type,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.pointHistory, {
        'type': type,
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
    );
    return PointHistoryResponse.fromJson(response);
  }

  Future<PointStats> getPointStats() async {
    final response = await _apiClient.get(ApiEndpoints.pointStats);
    return PointStats.fromJson(response);
  }

  Future<PointRedeemResponse> redeemPoints({
    required int points,
    required String description,
    int? productId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.pointRedeem,
      body: {
        'points': points,
        'description': description,
        if (productId != null) 'product_id': productId,
      },
    );
    return PointRedeemResponse.fromJson(response);
  }

  Future<ConsultationProductListResponse> getConsultationProducts({
    String? expertUuid,
    String? type,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.consultationProducts, {
        'expert_uuid': expertUuid,
        'type': type,
      }),
    );
    return ConsultationProductListResponse.fromJson(response);
  }

  Future<ConsultationProduct> getConsultationProductDetail(
    String productUuid,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.consultationProductDetail(productUuid),
    );
    return ConsultationProduct.fromJson(ApiParser.map(response['data']));
  }

  Future<ConsultationProductListResponse> getExpertConsultationProducts({
    required String expertUuid,
    String? type,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.expertConsultationProducts(expertUuid), {
        'type': type,
      }),
    );
    return ConsultationProductListResponse.fromJson(response);
  }

  Future<ConsultationCheckoutResponse> checkoutExpertConsultation({
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

  Future<ExpertAgendaListResponse> getExpertAgenda({
    String? type,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.expertMyConsultations, {
        'type': type,
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
    );
    return ExpertAgendaListResponse.fromJson(response);
  }

  Future<JsonMap> searchContents({
    required String query,
    String type = 'all',
    String? filterTopic,
    int page = 1,
    int perPage = 15,
  }) {
    return _apiClient.get(
      _withQuery(ApiEndpoints.search, {
        'q': query,
        'type': type,
        'filter_topic': filterTopic,
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
    );
  }

  Future<SupportTicketListResponse> getTickets({
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiClient.get(
      _withQuery(ApiEndpoints.tickets, {
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
    );
    return SupportTicketListResponse.fromJson(response);
  }

  Future<SupportTicket> getTicketDetail(String ticketUuid) async {
    final response = await _apiClient.get(
      ApiEndpoints.ticketDetail(ticketUuid),
    );
    return SupportTicket.fromJson(ApiParser.map(response['data']));
  }

  Future<SupportTicket> createTicket({required String issue}) async {
    final response = await _apiClient.post(
      ApiEndpoints.tickets,
      body: {'issue': issue},
    );
    return SupportTicket.fromJson(ApiParser.map(response['data']));
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
