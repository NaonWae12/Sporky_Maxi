import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const _tokenKey = "token";
  static const _userUuidKey = "user_uuid";
  static const _userNameKey = "user_name";
  static const _userRoleKey = "user_role";
  static const _selectedChildUuidKey = "selected_child_uuid";

  // ================= TOKEN =================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ================= USER UUID =================
  static Future<void> saveUserUuid(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUuidKey, uuid);
  }

  static Future<String?> getUserUuid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userUuidKey);
  }

  static Future<void> deleteUserUuid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUuidKey);
  }

  // ================= USER NAME =================
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<void> deleteUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
  }

  // ================= USER ROLE =================
  static Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  static Future<void> deleteUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userRoleKey);
  }

  // ================= SELECTED CHILD UUID =================
  static Future<void> saveSelectedChildUuid(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedChildUuidKey, uuid);
  }

  static Future<String?> getSelectedChildUuid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedChildUuidKey);
  }

  static Future<void> deleteSelectedChildUuid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedChildUuidKey);
  }

  // ================= LOGOUT =================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
