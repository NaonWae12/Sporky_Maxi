// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageServiceBc {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}

// class SecureStorageService {
//   static const _storage = FlutterSecureStorage();
//   static const _keyAccessToken = 'access_token';

//   // Simpan token
//   static Future<void> saveToken(String token) async {
//     await _storage.write(key: _keyAccessToken, value: token);
//   }

//   // Ambil token
//   static Future<String?> getToken() async {
//     return await _storage.read(key: _keyAccessToken);
//   }

//   // Hapus token
//   static Future<void> deleteToken() async {
//     await _storage.delete(key: _keyAccessToken);
//   }
// }
