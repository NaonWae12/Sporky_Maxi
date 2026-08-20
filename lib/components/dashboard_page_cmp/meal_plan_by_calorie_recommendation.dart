import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/meal_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/models/components/meal_plan_cmp_mdl/meal_plan_model.dart';
import 'package:sporky_maxi/views/meal_plan_page/detail_meal_plan.dart';

class MealPlanByCalorieRecommendation extends StatefulWidget {
  final String childUuid;

  const MealPlanByCalorieRecommendation({
    super.key,
    required this.childUuid,
  });

  @override
  State<MealPlanByCalorieRecommendation> createState() =>
      _MealPlanByCalorieRecommendationState();
}

class _MealPlanByCalorieRecommendationState
    extends State<MealPlanByCalorieRecommendation> {
  bool _isLoading = true;
  String? _alertMessage;
  String _alertState = '';
  bool _mealPlanVisible = false;
  List<MealPlan> _mealPlans = [];

  @override
  void initState() {
    super.initState();
    _fetchMealPlanByCalorie();
  }

  @override
  void didUpdateWidget(covariant MealPlanByCalorieRecommendation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.childUuid != widget.childUuid) {
      _fetchMealPlanByCalorie();
    }
  }

  Future<void> _fetchMealPlanByCalorie() async {
    if (widget.childUuid.isEmpty) return;

    if (!_isLoading) {
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
      });
    }

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('[MealPlanByCalorie] Token tidak ditemukan');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final url = ApiEndpoints.mealPlanByCalorie(widget.childUuid);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'];

        if (data is Map<String, dynamic>) {
          final calorieSummary = data['calorie_summary'];
          String? msg;
          String stateStr = '';

          if (calorieSummary is Map<String, dynamic>) {
            final alert = calorieSummary['alert'];
            if (alert is Map<String, dynamic>) {
              msg = alert['message']?.toString();
              stateStr = (alert['state'] ?? '').toString().toLowerCase();
            }
          }

          final visible = data['meal_plan_visible'] == true;
          final rawMeals = data['meal_plans'];
          final List<MealPlan> parsedMeals = [];

          if (rawMeals is List) {
            for (var item in rawMeals) {
              if (item is Map<String, dynamic>) {
                try {
                  parsedMeals.add(MealPlan.fromJson(item));
                } catch (e) {
                  debugPrint('[MealPlanByCalorie] Gagal parse meal: $e');
                }
              }
            }
          }

          if (mounted) {
            setState(() {
              _alertMessage = msg;
              _alertState = stateStr;
              _mealPlanVisible = visible;
              _mealPlans = parsedMeals;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) setState(() => _isLoading = false);
        }
      } else {
        debugPrint(
          '[MealPlanByCalorie] Gagal fetch (${response.statusCode}): ${response.body}',
        );
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('[MealPlanByCalorie] Error: $e');
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Tentukan warna dan ikon berdasarkan alert state dari API
    Color imageColor = AppColors.primary1;
    Color lineColor = AppColors.primary2;
    String imageAsset = 'assets/svg/ic_info.svg';

    if (_alertState == 'kurang') {
      imageColor = AppColors.warn1;
      lineColor = AppColors.warn1;
      imageAsset = 'assets/svg/ic_warn.svg';
    } else if (_alertState == 'cukup') {
      imageColor = AppColors.success2;
      lineColor = AppColors.success2;
      imageAsset = 'assets/svg/ic_success.svg';
    } else if (_alertState == 'lebih') {
      imageColor = AppColors.warn4;
      lineColor = AppColors.warn4;
      imageAsset = 'assets/svg/ic_warn.svg';
    }

    final hasAlert = _alertMessage != null && _alertMessage!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasAlert)
          CmpTagAttention(
            lineColor: lineColor,
            imageColor: imageColor,
            text: _alertMessage!,
            imageAsset: imageAsset,
          ),
        if (hasAlert && _mealPlanVisible && _mealPlans.isNotEmpty)
          const SizedBox(height: 16),
        if (_mealPlanVisible && _mealPlans.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  ..._mealPlans.map((meal) {
                    return MealCard(
                      mealPlanUuid: meal.uuid,
                      imagePath: _normalizeImageUrl(meal.imageUrl),
                      category: meal.name,
                      title: meal.name,
                      description: meal.subtitle.isNotEmpty
                          ? meal.subtitle
                          : 'Menu spesial hari ini',
                      calories: meal.calories,
                      categoryType: meal.displayType,
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
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
