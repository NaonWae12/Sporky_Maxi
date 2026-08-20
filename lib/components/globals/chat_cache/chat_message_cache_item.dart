class ChatMessageCacheItem {
  final String uuid;
  final String roomUuid;
  final String message;
  final bool isMe;
  final DateTime? createdAt;
  final DateTime? sentAt;
  final DateTime? readAt;
  final String status;

  const ChatMessageCacheItem({
    required this.uuid,
    required this.roomUuid,
    required this.message,
    required this.isMe,
    required this.createdAt,
    required this.sentAt,
    required this.readAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'room_uuid': roomUuid,
      'message': message,
      'is_me': isMe,
      'created_at': createdAt?.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'status': status,
    };
  }

  factory ChatMessageCacheItem.fromMap(Map<String, dynamic> map) {
    return ChatMessageCacheItem(
      uuid: (map['uuid']?.toString() ?? '').trim(),
      roomUuid: (map['room_uuid']?.toString() ?? '').trim(),
      message: (map['message']?.toString() ?? '').trim(),
      isMe: map['is_me'] == true,
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
      sentAt: DateTime.tryParse(map['sent_at']?.toString() ?? ''),
      readAt: DateTime.tryParse(map['read_at']?.toString() ?? ''),
      status: (map['status']?.toString() ?? 'sent').trim(),
    );
  }
}
