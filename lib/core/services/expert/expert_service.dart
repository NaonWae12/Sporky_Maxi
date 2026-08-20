import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../components/globals/constants/api_endpoints.dart';
import '../../utils/secure_storage_service.dart';

class ExpertService {
  Future<Map<String, dynamic>> getProfileMe() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    final url = ApiEndpoints.expertProfileMe;
    debugPrint('[ExpertService] Menembak URL: $url');
    debugPrint('[ExpertService] Token tersedia: ${token.isNotEmpty}');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    debugPrint('[ExpertService] Response Status: ${response.statusCode}');
    debugPrint('[ExpertService] Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonBody['data'] as Map<String, dynamic>? ?? {};
    }

    throw Exception('Gagal mengambil data profil expert: ${response.statusCode}');
  }
}
