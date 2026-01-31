import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../components/globals/constants/api_endpoints.dart';
import '../../../models/components/child/child_latest_screening_model.dart';
import '../../utils/secure_storage_service.dart';

class ScreeningService {
  Future<ChildLatestScreening> getLatestByChildUuid(String childUuid) async {
    // debugPrint("📌 [ScreeningService] childUuid: $childUuid");

    final token = await SecureStorageService.getToken();
    // debugPrint("🔑 Token: $token");

    if (token == null) {
      // debugPrint("❌ Token NULL");
      throw Exception("Token tidak ditemukan");
    }

    final url = ApiEndpoints.screeningLatestChild(childUuid);
    // debugPrint("🌐 Endpoint: $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );
    // debugPrint('token : $token');

    // debugPrint("📥 Status Code: ${response.statusCode}");
    // debugPrint("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      debugPrint("✅ Parsing screening berhasil");

      return ChildLatestScreening.fromJson(jsonBody['data']);
    } else {
      // debugPrint("❌ Gagal ambil screening anak");
      throw Exception("Gagal mengambil data screening");
    }
  }
}
