import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../components/globals/constants/api_endpoints.dart';
import '../../utils/secure_storage_service.dart';

class ChildService {
  Future<List<String>> getChildUuids() async {
    debugPrint("📌 [ChildService] getChildUuids dipanggil");

    final token = await SecureStorageService.getToken();
    // debugPrint("🔑 Token: $token");

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.children),
      headers: {
        'Authorization': token, // ⬅️ token sudah Bearer
        'Accept': 'application/json',
      },
    );

    // debugPrint("📥 Status Code: ${response.statusCode}");
    // debugPrint("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List children = body['data']['children'];

      debugPrint("👶 Jumlah anak: ${children.length}");

      return children.map<String>((child) => child['uuid'] as String).toList();
    }

    // 🔒 AUTH ERROR (BARU)
    if (response.statusCode == 401 || response.statusCode == 403) {
      debugPrint("🚨 Unauthorized / token revoked");
      throw Exception("Unauthorized");
    }

    // ❗ ERROR LAIN (NETWORK / SERVER)
    throw Exception(
      "Gagal mengambil list anak (${response.statusCode})",
    );
  }
}
