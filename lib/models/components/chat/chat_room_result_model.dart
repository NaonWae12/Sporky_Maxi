import 'package:sporky_maxi/models/api/api_parser.dart';

class ChatRoomResult {
  final String uuid;
  final String roomType;
  final String status;
  final String expertName;
  final String userName;

  const ChatRoomResult({
    required this.uuid,
    required this.roomType,
    required this.status,
    required this.expertName,
    required this.userName,
  });

  factory ChatRoomResult.fromJson(JsonMap json) {
    return ChatRoomResult(
      uuid: ApiParser.string(json['uuid']),
      roomType: ApiParser.string(json['room_type']),
      status: ApiParser.string(json['status']),
      expertName: ApiParser.string(json['participant_expert_name']),
      userName: ApiParser.string(json['participant_user_name']),
    );
  }
}
