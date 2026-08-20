import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../components/globals/constants/api_endpoints.dart';
import '../../../models/components/child/child_latest_screening_model.dart';
import '../../utils/secure_storage_service.dart';

class ScreeningService {
  Future<ChildLatestScreening> getLatestByChildUuid(String childUuid) async {
    // debugPrint('[ScreeningService] childUuid: $childUuid');

    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    final url = ApiEndpoints.screeningLatestChild(childUuid);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    debugPrint('[ScreeningService] status: ${response.statusCode}');
    // debugPrint('[ScreeningService] body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      final parsed = ChildLatestScreening.fromJson(
        jsonBody['data'] as Map<String, dynamic>? ?? {},
      );

      final screeningState = parsed.screening == null ? 'null' : 'available';
      debugPrint(
          '[ScreeningService] parse success (screening: $screeningState)');

      return parsed;
    }

    throw Exception('Gagal mengambil data screening');
  }
}
