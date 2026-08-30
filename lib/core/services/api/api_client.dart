import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

class ApiClient {
  const ApiClient({http.Client? httpClientForTest})
    : _httpClientForTest = httpClientForTest;

  final http.Client? _httpClientForTest;

  http.Client get _httpClient => _httpClientForTest ?? http.Client();

  Future<Map<String, dynamic>> get(String url) async {
    final response = await _httpClient.get(
      Uri.parse(url),
      headers: await _headers(),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    final response = await _httpClient.post(
      Uri.parse(url),
      headers: await _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    final response = await _httpClient.put(
      Uri.parse(url),
      headers: await _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    final response = await _httpClient.patch(
      Uri.parse(url),
      headers: await _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> multipart(
    String method,
    String url, {
    Map<String, String?> fields = const {},
    Map<String, String?> files = const {},
    bool authenticated = true,
  }) async {
    final request = http.MultipartRequest(method, Uri.parse(url));
    final headers = await _headers(authenticated: authenticated);
    headers.remove('Content-Type');
    request.headers.addAll(headers);

    for (final entry in fields.entries) {
      final value = entry.value?.trim();
      if (value != null && value.isNotEmpty) {
        request.fields[entry.key] = value;
      }
    }

    for (final entry in files.entries) {
      final path = entry.value?.trim();
      if (path != null && path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, path));
      }
    }

    final streamedResponse = await _httpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return _decode(response);
  }

  Future<Map<String, dynamic>> delete(String url) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: await _headers(),
    );
    return _decode(response);
  }

  Future<Map<String, String>> _headers({bool authenticated = true}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authenticated) {
      final token = await SecureStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token.startsWith('Bearer ')
            ? token
            : 'Bearer $token';
      }
    }

    return headers;
  }

  Future<Map<String, dynamic>> _decode(http.Response response) async {
    final dynamic body = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : {};

    if (response.statusCode == 401) {
      await SecureStorageService.clearAll();
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Map<String, dynamic>.from(body as Map);
    }

    if (body is Map<String, dynamic>) {
      throw ApiClientException(
        message: body['message']?.toString() ?? 'Request failed',
        statusCode: response.statusCode,
        body: body,
      );
    }

    throw ApiClientException(
      message: 'Request failed',
      statusCode: response.statusCode,
      body: const {},
    );
  }
}

class ApiClientException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic> body;

  ApiClientException({
    required this.message,
    required this.statusCode,
    required this.body,
  });
}
