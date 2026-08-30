import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _tokenKey = "token";
  static const _userUuidKey = "user_uuid";
  static const _userNameKey = "user_name";
  static const _userPhotoKey = "user_photo";
  static const _userRoleKey = "user_role";
  static const _selectedChildUuidKey = "selected_child_uuid";

  // ================= TOKEN =================
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ================= USER UUID =================
  static Future<void> saveUserUuid(String uuid) async {
    await _storage.write(key: _userUuidKey, value: uuid);
  }

  static Future<String?> getUserUuid() async {
    return _storage.read(key: _userUuidKey);
  }

  static Future<void> deleteUserUuid() async {
    await _storage.delete(key: _userUuidKey);
  }

  // ================= USER NAME =================
  static Future<void> saveUserName(String name) async {
    await _storage.write(key: _userNameKey, value: name);
  }

  static Future<String?> getUserName() async {
    return _storage.read(key: _userNameKey);
  }

  static Future<void> deleteUserName() async {
    await _storage.delete(key: _userNameKey);
  }

  // ================= USER PHOTO =================
  static Future<void> saveUserPhoto(String photoUrl) async {
    await _storage.write(key: _userPhotoKey, value: photoUrl);
  }

  static Future<String?> getUserPhoto() async {
    return _storage.read(key: _userPhotoKey);
  }

  static Future<void> deleteUserPhoto() async {
    await _storage.delete(key: _userPhotoKey);
  }

  // ================= USER ROLE =================
  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  static Future<String?> getUserRole() async {
    return _storage.read(key: _userRoleKey);
  }

  static Future<void> deleteUserRole() async {
    await _storage.delete(key: _userRoleKey);
  }

  // ================= SELECTED CHILD UUID =================
  static Future<void> saveSelectedChildUuid(String uuid) async {
    await _storage.write(key: _selectedChildUuidKey, value: uuid);
  }

  static Future<String?> getSelectedChildUuid() async {
    return _storage.read(key: _selectedChildUuidKey);
  }

  static Future<void> deleteSelectedChildUuid() async {
    await _storage.delete(key: _selectedChildUuidKey);
  }

  // ================= LOGOUT =================
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
