import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/components/profile/profile_models.dart';

class ProfileService {
  const ProfileService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ParentProfile> getParentProfile() async {
    final response = await _apiClient.get(ApiEndpoints.currentUser);
    final profile = ParentProfile.fromJson(ApiParser.map(response['data']));
    await syncParentProfileCache(profile);
    return profile;
  }

  Future<ParentProfile> updateParentProfile({
    String? name,
    String? gender,
    String? dob,
    String? phoneNumber,
    String? avatar,
    String? photoPath,
  }) async {
    final fields = <String, String?>{
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (gender != null && gender.isNotEmpty) 'gender': gender,
      if (dob != null && dob.isNotEmpty) 'dob': dob,
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty)
        'phone_number': phoneNumber.trim(),
      if (avatar != null && avatar.trim().isNotEmpty) ...{
        'photo_type': 'url',
        'photo_url': avatar.trim(),
      },
      if (photoPath != null && photoPath.trim().isNotEmpty)
        'photo_type': 'file',
    };

    final response = await _apiClient.multipart(
      'POST',
      ApiEndpoints.currentUser,
      fields: fields,
      files: {
        if (photoPath != null && photoPath.trim().isNotEmpty)
          'photo_file': photoPath.trim(),
      },
    );

    final profile = ParentProfile.fromJson(ApiParser.map(response['data']));
    await syncParentProfileCache(profile);
    return profile;
  }

  Future<ChildProfile> getChildProfile(String childUuid) async {
    final response = await _apiClient.get(ApiEndpoints.childDetail(childUuid));
    return ChildProfile.fromJson(ApiParser.map(response['data']));
  }

  Future<ChildProfile> updateChildProfile(
    String childUuid, {
    required String name,
    required String gender,
    required String dob,
    required List<String> medicalHistories,
    required List<String> allergies,
    required List<String> favoriteFoods,
    required List<String> foodsAvoided,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.childDetail(childUuid),
      body: {
        'name': name.trim(),
        'gender': gender,
        'dob': dob,
        'medical_histories': medicalHistories,
        'allergies': allergies,
        'favorite_foods': favoriteFoods,
        'foods_avoided': foodsAvoided,
      },
    );

    return ChildProfile.fromJson(ApiParser.map(response['data']));
  }

  Future<ExpertProfile> getExpertProfile() async {
    final response = await _apiClient.get(
      ApiEndpoints.expertProfessionalProfileMe,
    );
    return ExpertProfile.fromJson(ApiParser.map(response['data']));
  }

  Future<ExpertProfile> getExpertAccountProfile() async {
    final response = await _apiClient.get(ApiEndpoints.expertProfileMe);
    final profile = ExpertProfile.fromJson(ApiParser.map(response['data']));
    await syncExpertProfileCache(profile);
    return profile;
  }

  Future<ExpertProfile> updateExpertAccountProfile({
    String? name,
    String? phoneNumber,
    String? photoPath,
  }) async {
    final fields = <String, String?>{
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty)
        'phone_number': phoneNumber.trim(),
      if (photoPath != null && photoPath.trim().isNotEmpty)
        'photo_type': 'file',
    };

    final response = await _apiClient.multipart(
      'POST',
      ApiEndpoints.expertProfileMe,
      fields: fields,
      files: {
        if (photoPath != null && photoPath.trim().isNotEmpty)
          'photo_file': photoPath.trim(),
      },
    );

    final profile = ExpertProfile.fromJson(ApiParser.map(response['data']));
    await syncExpertProfileCache(profile);
    return profile;
  }

  Future<ExpertProfile> updateExpertProfile({
    String? specialization,
    int? experienceYears,
    List<String>? availableDays,
    String? availableTimeStart,
    String? availableTimeEnd,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.expertProfessionalProfileMe,
      body: {
        if (specialization != null && specialization.trim().isNotEmpty)
          'specialization': specialization.trim(),
        if (experienceYears != null) 'experience_years': experienceYears,
        if (availableDays != null) 'available_days': availableDays,
        if (availableTimeStart != null && availableTimeStart.isNotEmpty)
          'available_time_start': availableTimeStart,
        if (availableTimeEnd != null && availableTimeEnd.isNotEmpty)
          'available_time_end': availableTimeEnd,
      },
    );

    return ExpertProfile.fromJson(ApiParser.map(response['data']));
  }

  static Future<void> syncParentProfileCache(ParentProfile profile) async {
    if (profile.uuid.trim().isNotEmpty) {
      await SecureStorageService.saveUserUuid(profile.uuid.trim());
    }
    if (profile.name.trim().isNotEmpty) {
      await SecureStorageService.saveUserName(profile.name.trim());
    }
    final avatar = profile.avatar?.trim() ?? '';
    if (avatar.isNotEmpty) {
      await SecureStorageService.saveUserPhoto(avatar);
    }
  }

  static Future<void> syncExpertProfileCache(ExpertProfile profile) async {
    if (profile.name.trim().isNotEmpty) {
      await SecureStorageService.saveUserName(profile.name.trim());
    }
    final photo = profile.photo?.trim() ?? '';
    if (photo.isNotEmpty) {
      await SecureStorageService.saveUserPhoto(photo);
    }
  }
}
