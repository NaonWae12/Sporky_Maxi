import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/core/services/explore/explore_content_service.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const storageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(storageChannel, (call) async {
        if (call.method == 'read') return null;
        if (call.method == 'deleteAll') return null;
        return null;
      });

  group('Pagination and payment verification', () {
    test('transactions use requested page and parse pagination', () async {
      var requestedPage = '';
      final client = MockClient((request) async {
        requestedPage = request.url.queryParameters['page'] ?? '';
        return http.Response(
          jsonEncode({
            'status': 'success',
            'data': {
              'transactions': [
                {
                  'uuid': 'transaction-uuid',
                  'payment_method': 'doku',
                  'status': 'completed',
                  'total_amount': 75000,
                  'date': '2026-01-01T10:00:00Z',
                  'product': null,
                  'created_at': '2026-01-01T10:00:00Z',
                  'updated_at': '2026-01-01T10:00:00Z',
                },
              ],
              'pagination': {
                'current_page': 2,
                'last_page': 5,
                'per_page': 20,
                'total': 100,
              },
            },
          }),
          200,
        );
      });

      final service = ApiFoundationService(
        apiClient: ApiClient(httpClientForTest: client),
      );
      final result = await service.getTransactions(page: 2, perPage: 20);

      expect(requestedPage, '2');
      expect(result.pagination.currentPage, 2);
      expect(result.pagination.lastPage, 5);
      expect(result.transactions.first.status, 'completed');
    });

    test('transaction detail verifies completed payment', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/v1/transactions/transaction-uuid');
        return http.Response(
          jsonEncode({
            'status': 'success',
            'data': {
              'uuid': 'transaction-uuid',
              'payment_method': 'doku',
              'status': 'completed',
              'total_amount': 75000,
              'date': '2026-01-01T10:00:00Z',
              'product': null,
              'created_at': '2026-01-01T10:00:00Z',
              'updated_at': '2026-01-01T10:00:00Z',
            },
          }),
          200,
        );
      });

      final service = ApiFoundationService(
        apiClient: ApiClient(httpClientForTest: client),
      );
      final transaction = await service.getTransactionDetail(
        'transaction-uuid',
      );

      expect(transaction.status, 'completed');
    });

    test('transactions parse consultation ticket payload', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/v1/transactions');
        expect(request.url.queryParameters['status'], 'completed');

        return http.Response(
          jsonEncode({
            'status': 'success',
            'data': {
              'transactions': [
                {
                  'uuid': 'transaction-uuid',
                  'order_id': 'CONS-ORDER-1',
                  'payment_method': 'doku',
                  'status': 'completed',
                  'total_amount': 75000,
                  'date': '2026-01-01T10:00:00Z',
                  'product': null,
                  'consultation_product': {
                    'uuid': 'product-uuid',
                    'type': 'chat',
                    'duration': 30,
                    'price': 75000,
                    'expert': {
                      'uuid': 'expert-profile-uuid',
                      'user_uuid': 'expert-user-uuid',
                      'name': 'dr. Test',
                      'role': 'doctor',
                      'rating': 4.8,
                      'photo': null,
                      'specialization': 'Spesialis Anak',
                      'available_days': ['Senin'],
                      'available_hours': '09.00 - 12.00 WIB',
                    },
                  },
                  'consultation': {
                    'uuid': 'consultation-uuid',
                    'type': 'chat',
                    'status': 'confirmed',
                    'date': '2026-01-02T10:00:00Z',
                    'zoom_link': null,
                    'chat_room_uuid': 'room-uuid',
                    'chat_room': {'uuid': 'room-uuid', 'status': 'active'},
                    'product': null,
                    'expert': null,
                  },
                  'child': {'uuid': 'child-uuid', 'name': 'Anak Test'},
                  'created_at': '2026-01-01T10:00:00Z',
                  'updated_at': '2026-01-01T10:00:00Z',
                },
              ],
              'pagination': {
                'current_page': 1,
                'last_page': 1,
                'per_page': 20,
                'total': 1,
              },
            },
          }),
          200,
        );
      });

      final service = ApiFoundationService(
        apiClient: ApiClient(httpClientForTest: client),
      );
      final result = await service.getTransactions(
        status: 'completed',
        perPage: 20,
      );
      final transaction = result.transactions.single;

      expect(transaction.isConsultation, isTrue);
      expect(transaction.orderId, 'CONS-ORDER-1');
      expect(transaction.consultationType, 'chat');
      expect(transaction.chatRoomUuid, 'room-uuid');
      expect(transaction.expert?.userUuid, 'expert-user-uuid');
      expect(transaction.child?.uuid, 'child-uuid');
    });

    test('explore search returns pagination metadata', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/v1/search');
        expect(request.url.queryParameters['type'], 'article');
        expect(request.url.queryParameters['page'], '2');

        return http.Response(
          jsonEncode({
            'status': 'success',
            'data': {
              'articles': {
                'items': [
                  {
                    'uuid': 'article-uuid',
                    'title': 'Artikel Test',
                    'subtitle': 'Subtitle',
                    'thumbnail': null,
                    'author': {'name': 'dr. Test'},
                    'tags': ['nutrisi'],
                    'total_views': 10,
                    'total_likes': 20,
                  },
                ],
                'pagination': {
                  'current_page': 2,
                  'last_page': 4,
                  'per_page': 20,
                  'total': 80,
                },
              },
            },
          }),
          200,
        );
      });

      final service = ExploreContentService(
        apiClient: ApiClient(httpClientForTest: client),
      );
      final page = await service.searchArticles(
        query: 'nutrisi',
        page: 2,
        perPage: 20,
      );

      expect(page.items, hasLength(1));
      expect(page.currentPage, 2);
      expect(page.lastPage, 4);
      expect(page.hasMore, isTrue);
    });
  });
}
