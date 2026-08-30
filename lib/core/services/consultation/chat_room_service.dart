import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/components/chat/chat_room_result_model.dart';

class ChatRoomService {
  const ChatRoomService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ChatRoomResult> getOrCreateConsultationRoom({
    required String expertUserUuid,
    required String childUuid,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.chatRoomGetOrCreate,
      body: {
        'expert_id': expertUserUuid,
        'child_uuid': childUuid,
        'room_type': 'konsultasi',
      },
    );

    return ChatRoomResult.fromJson(ApiParser.map(response['data']));
  }
}
