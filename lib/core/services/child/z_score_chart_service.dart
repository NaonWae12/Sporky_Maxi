import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../components/globals/constants/api_endpoints.dart';
import '../../../models/components/child/z_score_chart_point_model.dart';
import '../../utils/secure_storage_service.dart';

class ZScoreChartService {
  Future<List<ZScoreChartPoint>> getZScoreChart({
    required String childUuid,
    int limit = 30,
  }) async {
    debugPrint("📊 [ZScoreChartService] childUuid: $childUuid");

    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception("Token tidak ditemukan");

    final url = ApiEndpoints.zScoreChartByChild(childUuid, limit: limit);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    debugPrint("📥 Status Code zscore: ${response.statusCode}");
    debugPrint("📥 Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil data z-score chart");
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final pointsList = data['points'] as List<dynamic>;

    // sort by date ascending
    pointsList.sort((a, b) =>
        DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

    return pointsList.map((e) => ZScoreChartPoint.fromJson(e)).toList();
  }
}
