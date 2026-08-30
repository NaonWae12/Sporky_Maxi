import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sporky_maxi/core/services/consultation/chat_room_service.dart';
import 'package:sporky_maxi/core/services/consultation/consultation_service.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:flutter/services.dart';

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

  group('Consultation payment regression', () {
    test('loads experts and consultation products', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/api/v1/experts') {
          return http.Response(
            jsonEncode({
              'status': 'success',
              'data': {
                'experts': [
                  {
                    'uuid': 'expert-uuid',
                    'user_uuid': 'user-uuid',
                    'name': 'dr. Test',
                    'role': 'doctor',
                    'rating': 4.8,
                    'photo': 'photo.jpg',
                    'profil': 'Spesialis Anak',
                  },
                ],
              },
            }),
            200,
          );
        }

        if (request.url.path ==
            '/api/v1/experts/expert-uuid/consultation-products') {
          return http.Response(
            jsonEncode({
              'status': 'success',
              'data': [
                {
                  'uuid': 'product-uuid',
                  'type': 'chat',
                  'duration': 30,
                  'price': 75000,
                  'expert': null,
                  'created_at': null,
                },
              ],
            }),
            200,
          );
        }

        fail('Unexpected request: ${request.url}');
      });

      final service = ConsultationService(
        apiClient: ApiClient(httpClientForTest: client),
      );
      final experts = await service.getExperts();
      final products = await service.getExpertConsultationProducts(
        experts.first.profileUuid,
      );

      expect(experts, hasLength(1));
      expect(experts.first.name, 'dr. Test');
      expect(experts.first.profileUuid, 'expert-uuid');
      expect(products, hasLength(1));
      expect(products.first.type, 'chat');
      expect(products.first.price, 75000);
    });

    test('checkout returns checkout url', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/experts/checkout');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['expert_uuid'], 'expert-uuid');
        expect(body['product_uuid'], 'product-uuid');

        return http.Response(
          jsonEncode({
            'status': 'success',
            'message': 'Checkout initialized successfully',
            'data': {'checkout_url': 'https://example.test/checkout'},
          }),
          200,
        );
      });

      final service = ConsultationService(
        apiClient: ApiClient(httpClientForTest: client),
      );
      final result = await service.checkout(
        expertUuid: 'expert-uuid',
        productUuid: 'product-uuid',
        date: DateTime(2026, 1, 1, 10),
      );

      expect(result.checkoutUrl, 'https://example.test/checkout');
    });

    test('creates consultation chat room after payment', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/chat/rooms/get-or-create');

        return http.Response(
          jsonEncode({
            'status': 'success',
            'message': 'Room ready',
            'data': {
              'uuid': 'room-uuid',
              'room_type': 'konsultasi',
              'status': 'active',
              'participant_expert_name': 'dr. Test',
              'participant_user_name': 'Bunda Test',
            },
          }),
          201,
        );
      });

      final service = ChatRoomService(
        apiClient: ApiClient(httpClientForTest: client),
      );
      final room = await service.getOrCreateConsultationRoom(
        expertUserUuid: 'user-uuid',
        childUuid: 'child-uuid',
      );

      expect(room.uuid, 'room-uuid');
      expect(room.expertName, 'dr. Test');
      expect(room.roomType, 'konsultasi');
    });
  });
}
