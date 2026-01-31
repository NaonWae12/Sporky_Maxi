import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../components/globals/constants/api_endpoints.dart';
import '../../utils/secure_storage_service.dart';

class PutChildGrowthUpdatesService {
  Future<void> updateGrowthData({
    required String childUuid,
    required int height,
    required double weight,
  }) async {
    final token = await SecureStorageService.getToken();
    if (token == null) {
      // debugPrint("❌ [UpdateGrowth] Token tidak ditemukan");
      throw Exception("Token tidak ditemukan");
    }

    // debugPrint("📤 [UpdateGrowth] Kirim data:");
    // debugPrint("👶 child_id : $childUuid");
    // debugPrint("📏 height   : $height");
    // debugPrint("⚖️ weight   : $weight");

    final response = await http.post(
      Uri.parse(ApiEndpoints.updateGrowthData),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "child_id": childUuid,
        "height": height,
        "weight": weight,
      }),
    );

    debugPrint("📥 [UpdateGrowth] Status Code: ${response.statusCode}");
    debugPrint("📥 [UpdateGrowth] Response: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      // debugPrint("❌ [UpdateGrowth] Gagal update data");
      throw Exception("Gagal update data pertumbuhan anak");
    }

    // debugPrint("✅ [UpdateGrowth] Update data berhasil");
  }
}
