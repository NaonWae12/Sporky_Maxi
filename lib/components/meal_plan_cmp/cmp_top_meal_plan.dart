import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/views/meal_plan_page/detail_meal_plan.dart';
import 'package:sporky_maxi/views/meal_plan_page/meal_plan_page.dart';

import '../../core/services/child/child_service.dart';
import '../../core/utils/secure_storage_service.dart';
import '../../models/components/meal_plan_cmp_mdl/meal_plan_model.dart';
import '../globals/card/meal_card.dart';
import '../globals/colors/colors.dart';
import '../globals/constants/api_base_url.dart';
import '../globals/constants/api_endpoints.dart';
import '../globals/text/text_style.dart';

class _TopMealEntry {
  final MealPlan meal;
  final String displayType;

  const _TopMealEntry({required this.meal, required this.displayType});
}

class CmpTopMealPlan extends StatefulWidget {
  const CmpTopMealPlan({super.key});

  @override
  State<CmpTopMealPlan> createState() => _CmpTopMealPlanState();
}

class _CmpTopMealPlanState extends State<CmpTopMealPlan> {
  List<MealPlan> _mealPlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('[CmpTopMealPlan] Token tidak ditemukan');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final childUuids = await ChildService().getChildUuids();

      if (childUuids.isEmpty) {
        debugPrint('[CmpTopMealPlan] Tidak ada data anak terdaftar');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      String? childUuid = await SecureStorageService.getSelectedChildUuid();

      if (childUuid == null ||
          childUuid.isEmpty ||
          !childUuids.contains(childUuid)) {
        childUuid = childUuids.first;
        await SecureStorageService.saveSelectedChildUuid(childUuid);
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final uri = Uri.parse(ApiEndpoints.mealPlanRecommendation(childUuid));

      final response = await http.get(
        uri,
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('[CmpTopMealPlan] Response body: ${response.body}');
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        var mealsJson = _extractMealPlanList(decoded);
        // debugPrint('[CmpTopMealPlan] Raw mealsJson from API: $mealsJson');

        // FALLBACK: Jika rekomendasi kosong (misalnya karena EER null di database), ambil daftar meal plan umum
        if (mealsJson.isEmpty) {
          debugPrint(
              '[CmpTopMealPlan] Recommendation empty. Fetching general meal plans as fallback.');
          final fallbackResponse = await http.get(
            Uri.parse(ApiEndpoints.mealPlan),
            headers: {
              'Authorization': authHeader,
              'Accept': 'application/json',
            },
          );
          if (fallbackResponse.statusCode == 200) {
            final fallbackDecoded =
                jsonDecode(fallbackResponse.body) as Map<String, dynamic>;
            mealsJson = _extractMealPlanList(fallbackDecoded);
            debugPrint(
                '[CmpTopMealPlan] Fallback general mealsCount: ${mealsJson.length}');
          }
        }

        if (!mounted) return;
        setState(() {
          _mealPlans = mealsJson.map(MealPlan.fromJson).toList();
          _isLoading = false;
        });
      } else {
        debugPrint(
          '[CmpTopMealPlan] Gagal fetch (${response.statusCode}): ${response.body}',
        );
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('[CmpTopMealPlan] Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _extractMealPlanList(
    Map<String, dynamic> decoded,
  ) {
    final dataNode = decoded['data'];

    // Struktur: data.meal_plans -> List
    if (dataNode is Map<String, dynamic>) {
      final mealPlansNode = dataNode['meal_plans'];
      if (mealPlansNode is List) {
        return mealPlansNode.whereType<Map<String, dynamic>>().toList();
      }
    }

    // Fallback jika backend kirim list langsung di data
    if (dataNode is List) {
      return dataNode.whereType<Map<String, dynamic>>().toList();
    }

    return const <Map<String, dynamic>>[];
  }

  String _normalizeImageUrl(String imageUrl) {
    final url = imageUrl.trim();
    if (url.isEmpty) return 'assets/temp_img/meal1.png';

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    if (url.startsWith('assets/')) {
      return url;
    }

    if (url.startsWith('/')) {
      return '${ApiBaseUrl.baseUrl}$url';
    }

    return '${ApiBaseUrl.baseUrl}/$url';
  }

  String _formatTypeLabel(String rawType) {
    return rawType
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 248,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_mealPlans.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Text(
          'Belum ada rekomendasi menu untuk anak ini.',
          style: AppTextStyles.list1Regular(AppColors.base2),
        ),
      );
    }

    // 1. Urutan prioritas kategori
    final List<String> targetTypes = [
      'makan_pagi',
      'snack_pagi',
      'makan_siang',
      'snack_sore',
      'makan_malam',
    ];

    final List<_TopMealEntry> selectedEntries = [];
    final Set<String> selectedUuids = {};

    // 2. Pilih menu unik untuk tiap kategori
    for (final targetType in targetTypes) {
      for (final meal in _mealPlans) {
        if (!selectedUuids.contains(meal.uuid) &&
            meal.type.contains(targetType)) {
          selectedEntries.add(_TopMealEntry(
            meal: meal,
            displayType: _formatTypeLabel(targetType),
          ));
          selectedUuids.add(meal.uuid);
          break; // Lanjut ke tipe kategori berikutnya
        }
      }
    }

    // 3. Masukkan menu tersisa yang belum kepilih
    for (final meal in _mealPlans) {
      if (!selectedUuids.contains(meal.uuid)) {
        final defaultType = meal.type.isNotEmpty ? meal.type.first : 'menu';
        selectedEntries.add(_TopMealEntry(
          meal: meal,
          displayType: _formatTypeLabel(defaultType),
        ));
        selectedUuids.add(meal.uuid);
      }
    }

    final int totalMealPlan = selectedEntries.length;
    final List<_TopMealEntry> displayedEntries =
        totalMealPlan > 3 ? selectedEntries.take(5).toList() : selectedEntries;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayedEntries.map((entry) {
            final meal = entry.meal;
            return MealCard(
              mealPlanUuid: meal.uuid,
              imagePath: _normalizeImageUrl(meal.imageUrl),
              category: 'Rekomendasi',
              title: meal.name,
              description: meal.subtitle.isNotEmpty
                  ? meal.subtitle
                  : 'Menu pilihan terbaik hari ini',
              calories: meal.calories,
              categoryType: entry.displayType,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMealPlan(mealPlan: meal),
                  ),
                );
              },
            );
          }),
          if (totalMealPlan > 4)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MealPlanPage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 140,
                height: 248,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary1),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.base5,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.base1.withAlpha(120),
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      height: 45,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/bento-box-rounded.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            'Lihat Semua',
                            style: AppTextStyles.lable2Regular(AppColors.base5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
