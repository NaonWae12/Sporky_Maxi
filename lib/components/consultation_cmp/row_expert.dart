import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/consultation_cmp/card_doctor_cmp.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../views/consultation/more_page_consultation.dart';
import 'profile_expert.dart';

class RowExpert extends StatefulWidget {
  const RowExpert({super.key});

  @override
  State<RowExpert> createState() => _RowExpertState();
}

class _RowExpertState extends State<RowExpert> {
  static const String _fallbackDoctorName = 'Dokter Sporky';
  static const String _fallbackImagePath = 'assets/temp_img/dr.palomina1.jpg';

  late Future<List<_ExpertCardData>> _expertsFuture;

  @override
  void initState() {
    super.initState();
    _loadExperts();
  }

  void _loadExperts() {
    _expertsFuture = _fetchExperts();
  }

  Future<List<_ExpertCardData>> _fetchExperts() async {
    debugPrint('[RowExpert] Fetch experts started');
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('[RowExpert] Token missing');
      throw Exception('Token tidak ditemukan');
    }
    debugPrint('[RowExpert] Token found');
    debugPrint('[RowExpert] Endpoint: ${ApiEndpoints.experts}');

    final response = await http.get(
      Uri.parse(ApiEndpoints.experts),
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
      },
    );
    debugPrint('[RowExpert] Status code: ${response.statusCode}');
    debugPrint('[RowExpert] Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data expert (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final dataNode = body['data'];
    final data = dataNode is Map<String, dynamic> ? dataNode : {};
    final expertsNode = data['experts'] ?? data['users'];
    final users = (expertsNode is List ? expertsNode : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList();
    debugPrint('[RowExpert] Parsed users count: ${users.length}');
    if (expertsNode is! List) {
      debugPrint(
        '[RowExpert] Expected data.experts as List, got: ${expertsNode.runtimeType}',
      );
      debugPrint('[RowExpert] data keys: ${data.keys.toList()}');
    }

    return users.map(
      (user) {
        final userUuid = (user['user_uuid']?.toString() ?? '').trim();
        final expertUuid = userUuid.isNotEmpty
            ? userUuid
            : (user['uuid']?.toString() ?? '').trim();

        debugPrint('[RowExpert] user_uuid: $userUuid');
        debugPrint('[RowExpert] expert uuid payload: $expertUuid');

        return _ExpertCardData(
          expertId: _resolveExpertId(user),
          expertUuid: expertUuid,
          doctorName: _normalizeDoctorName(user['name'] as String?),
          imagePath: _normalizeImagePath(user['photo'] as String?),
          starCount: _normalizeStarCount(user['rating']),
        );
      },
    ).toList();
  }

  String _resolveExpertId(Map<String, dynamic> user) {
    const idKeys = ['id', 'expert_id', 'uuid', 'user_uuid'];
    for (final key in idKeys) {
      final value = user[key];
      final id = (value?.toString() ?? '').trim();
      if (id.isNotEmpty) return id;
    }
    return '';
  }

  String _normalizeDoctorName(String? doctorName) {
    final name = doctorName?.trim() ?? '';
    return name.isEmpty ? _fallbackDoctorName : name;
  }

  String _normalizeImagePath(String? imagePath) {
    final photo = imagePath?.trim() ?? '';
    if (photo.isEmpty) return _fallbackImagePath;

    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      return photo;
    }

    if (photo.startsWith('/')) {
      return "${ApiBaseUrl.baseUrl}$photo";
    }

    return "${ApiBaseUrl.baseUrl}/$photo";
  }

  String _normalizeStarCount(dynamic ratingValue) {
    if (ratingValue is num) {
      return ratingValue.toStringAsFixed(1);
    }

    final parsed = double.tryParse((ratingValue?.toString() ?? '').trim());
    if (parsed != null) {
      return parsed.toStringAsFixed(1);
    }

    return '0.0';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_ExpertCardData>>(
      future: _expertsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 220,
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(_loadExperts);
                },
                child: const Text('Gagal memuat expert. Coba lagi'),
              ),
            ),
          );
        }

        final experts = snapshot.data ?? [];
        final int totalCardDoctorCmp = experts.length;

        if (totalCardDoctorCmp == 0) {
          return const SizedBox(
            height: 220,
            child: Center(child: Text('Belum ada expert')),
          );
        }

        final displayedExperts =
            totalCardDoctorCmp > 3 ? experts.take(4).toList() : experts;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...displayedExperts.map(
                (expert) => CardDoctorCmp(
                  imagePath: expert.imagePath,
                  buyTicket: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileExpert(
                          expertId: expert.expertId,
                          expertUuid: expert.expertUuid,
                          doctorName: expert.doctorName,
                          starCount: expert.starCount,
                        ),
                      ),
                    );
                  },
                  categoryType: 'Dokter',
                  doctorName: expert.doctorName,
                  starCount: expert.starCount,
                  skill: 'Spesialis Anak, Tumbuh Kembang',
                ),
              ),
              if (totalCardDoctorCmp > 3)
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MorePageConsultation(),
                        ),
                      );
                    },
                    child: const Text('Lihat Semua'),
                  ),
                ),
              const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}

class _ExpertCardData {
  final String expertId;
  final String expertUuid;
  final String doctorName;
  final String imagePath;
  final String starCount;

  const _ExpertCardData({
    required this.expertId,
    required this.expertUuid,
    required this.doctorName,
    required this.imagePath,
    required this.starCount,
  });
}
