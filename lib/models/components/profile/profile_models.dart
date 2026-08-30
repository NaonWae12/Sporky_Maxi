import 'package:sporky_maxi/models/api/api_parser.dart';

import '../../../core/utils/profile_photo_resolver.dart';

class ParentProfile {
  final String uuid;
  final String name;
  final String email;
  final String phoneNumber;
  final String? avatar;
  final String? gender;
  final String? dob;

  const ParentProfile({
    required this.uuid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.gender,
    required this.dob,
  });

  factory ParentProfile.fromJson(JsonMap json) {
    return ParentProfile(
      uuid: ApiParser.string(json['uuid']),
      name: ApiParser.string(json['name']),
      email: ApiParser.string(json['email']),
      phoneNumber: ApiParser.string(json['phone_number']),
      avatar: ProfilePhotoResolver.resolve(json['avatar'] ?? json['photo']),
      gender: ApiParser.nullableString(json['gender']),
      dob: ApiParser.nullableString(json['dob']),
    );
  }
}

class ChildProfile {
  final String uuid;
  final String name;
  final String gender;
  final String dob;
  final String referralCode;
  final List<String> medicalHistories;
  final List<String> allergies;
  final List<String> favoriteFoods;
  final List<String> foodsAvoided;

  const ChildProfile({
    required this.uuid,
    required this.name,
    required this.gender,
    required this.dob,
    required this.referralCode,
    required this.medicalHistories,
    required this.allergies,
    required this.favoriteFoods,
    required this.foodsAvoided,
  });

  factory ChildProfile.fromJson(JsonMap json) {
    return ChildProfile(
      uuid: ApiParser.string(json['uuid']),
      name: ApiParser.string(json['name']),
      gender: ApiParser.string(json['gender']),
      dob: ApiParser.string(json['dob']),
      referralCode: ApiParser.string(json['referral_code']),
      medicalHistories: _stringList(json['medical_histories']),
      allergies: _stringList(json['allergies']),
      favoriteFoods: _stringList(json['favorite_foods']),
      foodsAvoided: _stringList(json['foods_avoided']),
    );
  }
}

class ExpertProfile {
  final String uuid;
  final String name;
  final String phoneNumber;
  final String? photo;
  final String specialization;
  final int experienceYears;
  final List<String> availableDays;
  final String availableTimeStart;
  final String availableTimeEnd;
  final String education;

  const ExpertProfile({
    required this.uuid,
    required this.name,
    required this.phoneNumber,
    required this.photo,
    required this.specialization,
    required this.experienceYears,
    required this.availableDays,
    required this.availableTimeStart,
    required this.availableTimeEnd,
    required this.education,
  });

  factory ExpertProfile.fromJson(JsonMap json) {
    return ExpertProfile(
      uuid: ApiParser.string(json['uuid']),
      name: ApiParser.string(json['name']),
      phoneNumber: ApiParser.string(json['phone_number']),
      photo: ProfilePhotoResolver.resolve(json['photo'] ?? json['avatar']),
      specialization: ApiParser.string(json['specialization']),
      experienceYears: ApiParser.integer(json['experience_years']),
      availableDays: _stringList(json['available_days']),
      availableTimeStart: ApiParser.string(json['available_time_start']),
      availableTimeEnd: ApiParser.string(json['available_time_end']),
      education: _educationText(json['education']),
    );
  }
}

List<String> _stringList(dynamic value) {
  if (value is! List) return <String>[];
  return value
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

String _educationText(dynamic value) {
  if (value is! List) return '';
  return value
      .whereType<Map>()
      .map((item) {
        final degree = item['degree']?.toString().trim() ?? '';
        final institution = item['institution']?.toString().trim() ?? '';
        final year = item['year']?.toString().trim() ?? '';
        return [
          degree,
          institution,
          year,
        ].where((part) => part.isNotEmpty).join(' - ');
      })
      .where((item) => item.isNotEmpty)
      .join('\n');
}
