import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

class AuthSessionManager {
  static Future<void> saveAuthData({
    required String token,
    required String userUuid,
    required String userRole,
    String? userName,
    String? userPhoto,
  }) async {
    await SecureStorageService.saveToken(token);
    await SecureStorageService.saveUserUuid(userUuid);
    await SecureStorageService.saveUserRole(userRole);
    if (userName != null && userName.isNotEmpty) {
      await SecureStorageService.saveUserName(userName);
    }
    if (userPhoto != null && userPhoto.isNotEmpty) {
      await SecureStorageService.saveUserPhoto(userPhoto);
    }
  }
}
