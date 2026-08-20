class ChatCacheKeys {
  static const String roomsBox = 'chat_rooms_box';
  static const String messagesBox = 'chat_messages_box';
  static const String metaBox = 'chat_meta_box';

  static String roomsKey(String scope) => 'rooms::$scope';
  static String messagesKey(String roomUuid) => 'messages::$roomUuid';
  static String roomLastSyncKey(String roomUuid) => 'last_sync::$roomUuid';
}
