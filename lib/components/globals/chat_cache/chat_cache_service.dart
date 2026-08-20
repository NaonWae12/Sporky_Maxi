import 'package:hive_flutter/hive_flutter.dart';

import 'chat_cache_keys.dart';
import 'chat_message_cache_item.dart';
import 'chat_room_cache_item.dart';

class ChatCacheService {
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
    await Hive.openBox<dynamic>(ChatCacheKeys.roomsBox);
    await Hive.openBox<dynamic>(ChatCacheKeys.messagesBox);
    await Hive.openBox<dynamic>(ChatCacheKeys.metaBox);

    _isInitialized = true;
  }

  static Future<List<ChatRoomCacheItem>> getRooms({
    String scope = 'parent',
  }) async {
    await init();
    final box = Hive.box<dynamic>(ChatCacheKeys.roomsBox);
    final raw = box.get(ChatCacheKeys.roomsKey(scope), defaultValue: const []);
    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(ChatRoomCacheItem.fromMap)
        .toList();
  }

  static Future<void> saveRooms(
    List<ChatRoomCacheItem> rooms, {
    String scope = 'parent',
  }) async {
    await init();
    final box = Hive.box<dynamic>(ChatCacheKeys.roomsBox);
    final payload = rooms.map((room) => room.toMap()).toList();
    await box.put(ChatCacheKeys.roomsKey(scope), payload);
  }

  static Future<List<ChatMessageCacheItem>> getMessages(String roomUuid) async {
    await init();
    final box = Hive.box<dynamic>(ChatCacheKeys.messagesBox);
    final raw = box.get(
      ChatCacheKeys.messagesKey(roomUuid),
      defaultValue: const [],
    );
    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(ChatMessageCacheItem.fromMap)
        .toList();
  }

  static Future<void> saveMessages(
    String roomUuid,
    List<ChatMessageCacheItem> messages,
  ) async {
    await init();
    final box = Hive.box<dynamic>(ChatCacheKeys.messagesBox);

    final deduped = <String, ChatMessageCacheItem>{};
    for (final message in messages) {
      final key = _messageKey(message);
      deduped[key] = message;
    }

    final payload = deduped.values.map((message) => message.toMap()).toList()
      ..sort((a, b) {
        final aTime = DateTime.tryParse(a['created_at']?.toString() ?? '')
                ?.millisecondsSinceEpoch ??
            0;
        final bTime = DateTime.tryParse(b['created_at']?.toString() ?? '')
                ?.millisecondsSinceEpoch ??
            0;
        return aTime.compareTo(bTime);
      });

    await box.put(ChatCacheKeys.messagesKey(roomUuid), payload);
    await setRoomLastSyncAt(roomUuid, DateTime.now());
  }

  static Future<void> appendMessage(
    String roomUuid,
    ChatMessageCacheItem message,
  ) async {
    final current = await getMessages(roomUuid);
    final updated = [...current, message];
    await saveMessages(roomUuid, updated);
  }

  static Future<DateTime?> getRoomLastSyncAt(String roomUuid) async {
    await init();
    final box = Hive.box<dynamic>(ChatCacheKeys.metaBox);
    final raw = box.get(ChatCacheKeys.roomLastSyncKey(roomUuid));
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  static Future<void> setRoomLastSyncAt(String roomUuid, DateTime value) async {
    await init();
    final box = Hive.box<dynamic>(ChatCacheKeys.metaBox);
    await box.put(ChatCacheKeys.roomLastSyncKey(roomUuid), value.toIso8601String());
  }

  static String _messageKey(ChatMessageCacheItem message) {
    if (message.uuid.isNotEmpty) return 'uuid:${message.uuid}';
    final millis = message.createdAt?.millisecondsSinceEpoch ?? 0;
    return 'fallback:${message.roomUuid}:${message.isMe}:${message.message}:$millis';
  }
}
