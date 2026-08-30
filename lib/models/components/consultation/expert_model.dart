import 'package:sporky_maxi/models/api/api_parser.dart';

class ExpertItem {
  final String uuid;
  final String userUuid;
  final String name;
  final String role;
  final double rating;
  final String photo;
  final String specialization;
  final List<String> tags;

  const ExpertItem({
    required this.uuid,
    required this.userUuid,
    required this.name,
    required this.role,
    required this.rating,
    required this.photo,
    required this.specialization,
    required this.tags,
  });

  factory ExpertItem.fromJson(JsonMap json) {
    return ExpertItem(
      uuid: ApiParser.string(json['uuid']),
      userUuid: ApiParser.string(json['user_uuid']),
      name: ApiParser.string(json['name'], 'Dokter Sporky'),
      role: ApiParser.string(json['role'], 'doctor'),
      rating: ApiParser.decimal(json['rating']),
      photo: ApiParser.string(json['photo']),
      specialization: ApiParser.string(json['profil']),
      tags: _stringList(json['tags']),
    );
  }

  String get profileUuid => uuid.isNotEmpty ? uuid : userUuid;
}

List<String> _stringList(dynamic value) {
  if (value is! List) return <String>[];
  return value
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList();
}
