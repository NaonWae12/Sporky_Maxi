import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../../core/utils/secure_storage_service.dart';
import '../../../../models/components/child/child_profile_dashboard_model.dart';

/// Menampilkan ringkasan biodata kesehatan anak di halaman Dashboard:
/// riwayat penyakit, alergi, makanan favorit, dan makanan yang dihindari.
class ChildBiodataCmp extends StatefulWidget {
  final String childUuid;

  const ChildBiodataCmp({
    super.key,
    required this.childUuid,
  });

  @override
  State<ChildBiodataCmp> createState() => _ChildBiodataCmpState();
}

class _ChildBiodataCmpState extends State<ChildBiodataCmp> {
  ChildProfileDashboard? _profile;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void didUpdateWidget(covariant ChildBiodataCmp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.childUuid != widget.childUuid) {
      _fetchProfile();
    }
  }

  Future<void> _fetchProfile() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _profile = null;
    });

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) setState(() => _hasError = true);
        return;
      }
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      final uri = Uri.parse(ApiEndpoints.childProfileDashboard(widget.childUuid));
      debugPrint('[ChildBiodataCmp] GET $uri');

      final response = await http.get(uri, headers: {
        'Authorization': authHeader,
        'Accept': 'application/json',
      });

      debugPrint('[ChildBiodataCmp] status: ${response.statusCode}');

      if (response.statusCode != 200) {
        if (mounted) setState(() => _hasError = true);
        return;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final profile = ChildProfileDashboard.fromJson(decoded);

      if (mounted) {
        setState(() {
          _profile = profile;
        });
      }
    } catch (e) {
      debugPrint('[ChildBiodataCmp] error: $e');
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || _profile == null) {
      return const SizedBox.shrink();
    }

    final p = _profile!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlobalsCard(
        backgroundColor: AppColors.base5,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Informasi Kesehatan Anak',
                  style: AppTextStyles.headList1Bold(AppColors.base1),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _BiodataRow(
              icon: Icons.medical_services_outlined,
              iconColor: AppColors.warn1,
              title: 'Riwayat Penyakit',
              items: p.conditions,
              emptyLabel: 'Tidak ada riwayat penyakit',
            ),
            const SizedBox(height: 8),
            _BiodataRow(
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.warn4,
              title: 'Alergi',
              items: p.allergies,
              emptyLabel: 'Tidak ada alergi',
            ),
            const SizedBox(height: 8),
            _BiodataRow(
              icon: Icons.favorite_outline_rounded,
              iconColor: AppColors.success2,
              title: 'Makanan Favorit',
              items: p.favoriteFoods,
              emptyLabel: 'Belum ada makanan favorit',
            ),
            const SizedBox(height: 8),
            _BiodataRow(
              icon: Icons.block_rounded,
              iconColor: AppColors.secondary2,
              title: 'Makanan yang Dihindari',
              items: p.avoidedFoods,
              emptyLabel: 'Tidak ada makanan yang dihindari',
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu baris informasi biodata dengan chip tag untuk setiap item.
class _BiodataRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<String> items;
  final String emptyLabel;

  const _BiodataRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.items,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.base4,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.list3SemiBold(AppColors.base2),
              ),
            ],
          ),
          const SizedBox(height: 6),
          items.isEmpty
              ? Text(
                  emptyLabel,
                  style: AppTextStyles.headList1Regular(AppColors.base2),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: items.map((item) => _Chip(label: item)).toList(),
                ),
        ],
      ),
    );
  }
}

/// Chip kecil untuk setiap tag item (penyakit, alergi, makanan, dll).
class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary3,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary2, width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.list3SemiBold(AppColors.secondary1),
      ),
    );
  }
}
