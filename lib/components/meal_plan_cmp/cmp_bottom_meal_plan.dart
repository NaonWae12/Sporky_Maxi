import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/secure_storage_service.dart';
import '../../models/components/meal_plan_cmp_mdl/meal_plan_model.dart';
import '../../views/meal_plan_page/detail_meal_plan.dart';
import '../../views/meal_plan_page/meal_plan_page.dart';
import '../globals/card/meal_card.dart';
import '../globals/colors/colors.dart';
import '../globals/constants/api_base_url.dart';
import '../globals/constants/api_endpoints.dart';
import '../globals/text/text_style.dart';

/// Urutan slot tampil di UI
const _slotOrder = [
  'makan_pagi',
  'snack_pagi',
  'makan_siang',
  'snack_sore',
  'makan_malam',
];

class CmpBottomMealPlan extends StatefulWidget {
  const CmpBottomMealPlan({super.key});

  @override
  State<CmpBottomMealPlan> createState() => _CmpBottomMealPlanState();
}

class _CmpBottomMealPlanState extends State<CmpBottomMealPlan> {
  /// List berisi entry (slotKey, MealPlan) sesuai urutan _slotOrder
  List<({String slotKey, MealPlan meal})> _slots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDailyMealPlan();
  }

  Future<void> _fetchDailyMealPlan() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('[CmpBottomMealPlan] Token tidak ditemukan');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final childUuid = await SecureStorageService.getSelectedChildUuid();
      if (childUuid == null || childUuid.isEmpty) {
        debugPrint('[CmpBottomMealPlan] Child UUID tidak ditemukan');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      final response = await http.get(
        Uri.parse(ApiEndpoints.mealPlanDaily(childUuid)),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'];

        if (data is! Map<String, dynamic>) {
          if (mounted) setState(() => _isLoading = false);
          return;
        }

        final mealSlots = data['meal_slots'];
        if (mealSlots is! Map<String, dynamic>) {
          if (mounted) setState(() => _isLoading = false);
          return;
        }

        final List<({String slotKey, MealPlan meal})> result = [];
        for (final key in _slotOrder) {
          final slotData = mealSlots[key];
          if (slotData is Map<String, dynamic>) {
            try {
              final meal = MealPlan.fromJson(slotData);
              result.add((slotKey: key, meal: meal));
              debugPrint('[CmpBottomMealPlan] slot=$key, name=${meal.name}');
            } catch (e) {
              debugPrint('[CmpBottomMealPlan] Gagal parse slot $key: $e');
            }
          }
        }

        if (mounted) {
          setState(() {
            _slots = result;
            _isLoading = false;
          });
        }
      } else {
        debugPrint(
          '[CmpBottomMealPlan] Gagal fetch daily (${response.statusCode}): ${response.body}',
        );
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('[CmpBottomMealPlan] Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _normalizeImageUrl(String imageUrl) {
    final url = imageUrl.trim();
    if (url.isEmpty) return 'assets/temp_img/meal1.png';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('assets/')) return url;
    if (url.startsWith('/')) return '${ApiBaseUrl.baseUrl}$url';
    return '${ApiBaseUrl.baseUrl}/$url';
  }

  String _slotLabel(String key) {
    return key
        .split('_')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Belum ada rekomendasi menu harian.',
          style: AppTextStyles.list1Regular(AppColors.base2),
        ),
      );
    }

    final int totalSlots = _slots.length;
    final displayedSlots = totalSlots > 5 ? _slots.take(5).toList() : _slots;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayedSlots.map((entry) {
            return MealCard(
              mealPlanUuid: entry.meal.uuid,
              imagePath: _normalizeImageUrl(entry.meal.imageUrl),
              category: entry.meal.name,
              title: entry.meal.name,
              description: entry.meal.subtitle.isNotEmpty
                  ? entry.meal.subtitle
                  : 'Menu spesial hari ini',
              calories: entry.meal.calories,
              categoryType: _slotLabel(entry.slotKey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMealPlan(mealPlan: entry.meal),
                  ),
                );
              },
            );
          }),
          if (totalSlots >= 4)
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
