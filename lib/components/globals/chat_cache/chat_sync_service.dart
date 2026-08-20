import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/utils/secure_storage_service.dart';
import '../constants/api_endpoints.dart';
import 'chat_message_cache_item.dart';
import 'chat_room_cache_item.dart';
import '../../../models/components/chat/chat_child_profile_model.dart';

class ChatSyncService {
  static Future<String> _getRequiredToken() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }
    return token;
  }

  static Future<List<ChatRoomCacheItem>> fetchRooms({
    String roomTypeFilter = 'konsultasi',
    bool preferParticipantExpertName = true,
  }) async {
    final token = await _getRequiredToken();

    final response = await http.get(
      Uri.parse(ApiEndpoints.chatRooms),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil room chat (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final rawData = body['data'];
    if (rawData is! List) return const [];

    return rawData
        .whereType<Map<String, dynamic>>()
        .where((room) {
          final roomType =
              (room['room_type']?.toString() ?? '').trim().toLowerCase();
          return roomType == roomTypeFilter.toLowerCase();
        })
        .map(
          (room) => _toRoomItem(
            room,
            preferParticipantExpertName: preferParticipantExpertName,
          ),
        )
        .toList();
  }

  static ChatRoomCacheItem _toRoomItem(
    Map<String, dynamic> json, {
    required bool preferParticipantExpertName,
  }) {
    final participantExpertName =
        (json['participant_expert_name']?.toString() ?? '').trim();
    final participantUserName =
        (json['participant_user_name']?.toString() ?? '').trim();
    final unreadRaw = json['unread_count'];
    final unreadCount = unreadRaw is int
        ? unreadRaw
        : int.tryParse(unreadRaw?.toString() ?? '') ?? 0;

    final displayName = preferParticipantExpertName
        ? (participantExpertName.isNotEmpty
            ? participantExpertName
            : participantUserName)
        : (participantUserName.isNotEmpty
            ? participantUserName
            : participantExpertName);

    final childUuid = _resolveChildUuid(json);

    return ChatRoomCacheItem(
      uuid: (json['uuid']?.toString() ?? '').trim(),
      roomType: (json['room_type']?.toString() ?? '').trim(),
      childUuid: childUuid,
      displayName: displayName,
      unreadCount: unreadCount,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  static String _resolveChildUuid(Map<String, dynamic> json) {
    String readDirect(List<String> keys) {
      for (final key in keys) {
        final value = (json[key]?.toString() ?? '').trim();
        if (value.isNotEmpty) return value;
      }
      return '';
    }

    final fromDirect = readDirect(const ['child_uuid', 'childUuid']);
    if (fromDirect.isNotEmpty) return fromDirect;

    final childNode = json['child'];
    if (childNode is Map<String, dynamic>) {
      final fromChildNode = (childNode['uuid']?.toString() ?? '').trim();
      if (fromChildNode.isNotEmpty) return fromChildNode;
    }

    return '';
  }

  static Future<ChatChildProfile> fetchChildProfile(String roomUuid) async {
    final token = await _getRequiredToken();

    final response = await http.get(
      Uri.parse(ApiEndpoints.chatRoomChildProfile(roomUuid)),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat profil anak (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ChatChildProfile.fromJson(body);
  }

  static Future<List<ChatMessageCacheItem>> fetchMessages({
    required String roomUuid,
    String? currentUserUuid,
    bool viewerIsExpert = false,
  }) async {
    final token = await _getRequiredToken();

    final response = await http.get(
      Uri.parse(ApiEndpoints.chatRoomMessages(roomUuid)),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat pesan (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final extracted = _extractMessages(body['data']);
    if (extracted == null) return const [];

    final messages = extracted
        .map((json) => _toMessageItem(
              roomUuid: roomUuid,
              json: json,
              currentUserUuid: currentUserUuid,
              viewerIsExpert: viewerIsExpert,
            ))
        .toList()
      ..sort((a, b) {
        final aMillis = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bMillis = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return aMillis.compareTo(bMillis);
      });

    return messages;
  }

  static List<Map<String, dynamic>>? _extractMessages(dynamic bodyData) {
    List<Map<String, dynamic>> toMessageMapList(dynamic source) {
      if (source is! List) return <Map<String, dynamic>>[];
      return source.whereType<Map<String, dynamic>>().toList();
    }

    if (bodyData is List) {
      return toMessageMapList(bodyData);
    }

    if (bodyData is Map<String, dynamic>) {
      const candidates = ['messages', 'items', 'chats', 'results', 'data'];
      for (final key in candidates) {
        final value = bodyData[key];
        if (value is List) return toMessageMapList(value);
        if (value is Map<String, dynamic>) {
          for (final nested in candidates) {
            final nestedValue = value[nested];
            if (nestedValue is List) return toMessageMapList(nestedValue);
          }
        }
      }
    }

    return null;
  }

  static ChatMessageCacheItem _toMessageItem({
    required String roomUuid,
    required Map<String, dynamic> json,
    required String? currentUserUuid,
    required bool viewerIsExpert,
  }) {
    String readString(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        final text = value.toString().trim();
        if (text.isNotEmpty) return text;
      }
      return fallback;
    }

    DateTime? readDate(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        final parsed = DateTime.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
      return null;
    }

    bool resolveIsMe() {
      final directFlag = json['is_me'];
      if (directFlag is bool) return directFlag;

      final sender = json['sender'];
      if (sender is Map<String, dynamic>) {
        final senderUuid = sender['uuid']?.toString().trim() ?? '';
        if ((currentUserUuid ?? '').trim().isNotEmpty &&
            senderUuid == (currentUserUuid ?? '').trim()) {
          return true;
        }

        final senderRole =
            sender['role']?.toString().trim().toLowerCase() ?? '';
        final fromParent = senderRole == 'user' || senderRole == 'parent';
        final fromExpert = senderRole == 'expert' || senderRole == 'doctor';
        if (fromParent) return !viewerIsExpert;
        if (fromExpert) return viewerIsExpert;
      }

      final senderType = readString(
        ['sender_type', 'sender_role', 'from'],
      ).toLowerCase();

      if (senderType.contains('expert') || senderType.contains('doctor')) {
        return viewerIsExpert;
      }
      if (senderType.contains('user') || senderType.contains('parent')) {
        return !viewerIsExpert;
      }

      return false;
    }

    final createdAt = readDate(['created_at', 'sent_at', 'updated_at']);
    final sentAt = readDate(['sent_at', 'created_at']);
    final readAt = readDate(['read_at']);
    final isMe = resolveIsMe();

    return ChatMessageCacheItem(
      uuid: readString(['uuid'], fallback: ''),
      roomUuid: roomUuid,
      message: readString(
        ['message', 'content', 'text', 'body'],
        fallback: '(pesan kosong)',
      ),
      isMe: isMe,
      createdAt: createdAt,
      sentAt: sentAt,
      readAt: readAt,
      status: _resolveStatus(
        isMe: isMe,
        sentAt: sentAt,
        readAt: readAt,
      ),
    );
  }

  static String _resolveStatus({
    required bool isMe,
    required DateTime? sentAt,
    required DateTime? readAt,
  }) {
    if (!isMe) return 'sent';
    if (readAt != null) return 'read';
    if (sentAt != null) return 'delivered';
    return 'sent';
  }
}
