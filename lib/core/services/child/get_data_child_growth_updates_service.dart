import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../components/globals/constants/api_endpoints.dart';
import '../../../models/components/child/child_growth_updates_model.dart';
import '../../utils/secure_storage_service.dart';

class ChildDropdownService {
  Future<List<ChildGrowthUpdatesModel>> getChildren() async {
    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await http.get(
      Uri.parse(ApiEndpoints.children),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List children = body['data']['children'];

      return children.map((e) => ChildGrowthUpdatesModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data anak");
    }
  }
}
