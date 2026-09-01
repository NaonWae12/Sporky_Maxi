import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';

class QontakMobileChatSession {
  final String webviewUrl;
  final String contactId;
  final String externalId;
  final String title;
  final String description;
  final String themeColor;

  const QontakMobileChatSession({
    required this.webviewUrl,
    this.contactId = '',
    this.externalId = '',
    this.title = 'Chatbot Sporky',
    this.description = '',
    this.themeColor = '',
  });

  factory QontakMobileChatSession.fromJson(Map<String, dynamic> json) {
    final widget = json['widget'] is Map
        ? Map<String, dynamic>.from(json['widget'] as Map)
        : <String, dynamic>{};

    return QontakMobileChatSession(
      webviewUrl: json['webview_url']?.toString() ?? '',
      contactId: json['contact_id']?.toString() ?? '',
      externalId: json['external_id']?.toString() ?? '',
      title: widget['header_text']?.toString().trim().isNotEmpty == true
          ? widget['header_text'].toString()
          : 'Chatbot Sporky',
      description: widget['description_text']?.toString() ?? '',
      themeColor: widget['theme_color']?.toString() ?? '',
    );
  }
}

class QontakMobileChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime? createdAt;

  const QontakMobileChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    this.createdAt,
  });

  factory QontakMobileChatMessage.fromJson(Map<String, dynamic> json) {
    return QontakMobileChatMessage(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      isMe: json['is_me'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

class QontakMobileChatMessagesResult {
  final List<QontakMobileChatMessage> messages;
  final String nextCursor;

  const QontakMobileChatMessagesResult({
    required this.messages,
    required this.nextCursor,
  });
}

class QontakMobileChatService {
  const QontakMobileChatService({this.apiClient = const ApiClient()});

  final ApiClient apiClient;

  Future<QontakMobileChatSession> createSession() async {
    final response = await apiClient.get(ApiEndpoints.qontakMobileChatSession);
    final data = response['data'] is Map
        ? Map<String, dynamic>.from(response['data'] as Map)
        : <String, dynamic>{};
    final session = QontakMobileChatSession.fromJson(data);

    if (session.webviewUrl.isEmpty) {
      throw const QontakMobileChatException(
        'Session Qontak tidak mengembalikan URL chat.',
      );
    }

    return session;
  }

  Future<QontakMobileChatMessagesResult> getMessages({String? cursor}) async {
    var url = ApiEndpoints.qontakMobileChatMessages;
    if (cursor != null && cursor.trim().isNotEmpty) {
      url += '?cursor=${Uri.encodeQueryComponent(cursor)}';
    }

    final response = await apiClient.get(url);
    final data = ApiParser.map(response['data']);
    final rawMessages = data['messages'];
    final messages = rawMessages is List
        ? rawMessages
              .whereType<Map>()
              .map(
                (message) => QontakMobileChatMessage.fromJson(
                  Map<String, dynamic>.from(message),
                ),
              )
              .toList()
        : <QontakMobileChatMessage>[];

    return QontakMobileChatMessagesResult(
      messages: messages,
      nextCursor: data['next_cursor']?.toString() ?? '',
    );
  }

  Future<QontakMobileChatMessage> sendMessage(String message) async {
    final response = await apiClient.post(
      ApiEndpoints.qontakMobileChatMessages,
      body: {'message': message},
    );

    return QontakMobileChatMessage.fromJson(ApiParser.map(response['data']));
  }
}

class QontakMobileChatException implements Exception {
  final String message;

  const QontakMobileChatException(this.message);

  @override
  String toString() => message;
}
