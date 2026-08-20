class ChatRoomCacheItem {
  final String uuid;
  final String roomType;
  final String childUuid;
  final String displayName;
  final int unreadCount;
  final DateTime? updatedAt;

  const ChatRoomCacheItem({
    required this.uuid,
    required this.roomType,
    required this.childUuid,
    required this.displayName,
    required this.unreadCount,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'room_type': roomType,
      'child_uuid': childUuid,
      'display_name': displayName,
      'unread_count': unreadCount,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ChatRoomCacheItem.fromMap(Map<String, dynamic> map) {
    final unreadRaw = map['unread_count'];
    final unreadCount = unreadRaw is int
        ? unreadRaw
        : int.tryParse(unreadRaw?.toString() ?? '') ?? 0;

    return ChatRoomCacheItem(
      uuid: (map['uuid']?.toString() ?? '').trim(),
      roomType: (map['room_type']?.toString() ?? '').trim(),
      childUuid: (map['child_uuid']?.toString() ?? '').trim(),
      displayName: (map['display_name']?.toString() ?? '').trim(),
      unreadCount: unreadCount,
      updatedAt: DateTime.tryParse(map['updated_at']?.toString() ?? ''),
    );
  }
}
