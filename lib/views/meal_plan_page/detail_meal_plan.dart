import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/detail_meal_plan_cmp/bottom_content_meal.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/detail_meal_plan_cmp/middle_content_meal.dart';
import 'package:sporky_maxi/components/meal_plan_cmp/detail_meal_plan_cmp/top_content_meal.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../models/components/meal_plan_cmp_mdl/nutrien_card_data.dart';
import '../../models/components/meal_plan_cmp_mdl/meal_plan_model.dart';

class DetailMealPlan extends StatefulWidget {
  const DetailMealPlan({
    super.key,
    required this.mealPlan,
  });

  final MealPlan mealPlan;

  @override
  State<DetailMealPlan> createState() => _DetailMealPlanState();
}

class _DetailMealPlanState extends State<DetailMealPlan> {
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchLikesCount();
  }

  Future<void> _fetchLikesCount() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(
            ApiEndpoints.mealPlanGlobalFavoriteCount(widget.mealPlan.uuid)),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final dataNode = decoded['data'];
        if (dataNode != null && dataNode['total_global_favorites'] != null) {
          final count =
              int.tryParse(dataNode['total_global_favorites'].toString()) ?? 0;
          if (mounted) {
            setState(() {
              _likesCount = count;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('[DetailMealPlan] Error fetching likes: $e');
    }

    if (mounted) {
      setState(() {
        _likesCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width,
          automaticallyImplyLeading: false,
          leading: Row(
            children: [
              const SizedBox(width: 5),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text('Detail Meal Plan', style: AppTextStyles.heading2SemiBold())
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopContentMeal(
              mealPlanUuid: widget.mealPlan.uuid,
              imageAsset: widget.mealPlan.imageUrl,
              title: widget.mealPlan.name,
              subtitle: widget.mealPlan.subtitle,
              likes: _likesCount,
              categories: widget.mealPlan.displayType,
              value: widget.mealPlan.calories.toStringAsFixed(0),
              nutrientCards: [
                NutrientCardData(
                  label: 'Karbohidrat',
                  labelCategory: 'gr',
                  labelValue: widget.mealPlan.carbohydrate.toStringAsFixed(0),
                  imageAsset: 'assets/svg/ic_nutrition.svg',
                ),
                NutrientCardData(
                  label: 'Lemak',
                  labelCategory: 'gr',
                  labelValue: widget.mealPlan.fat.toStringAsFixed(0),
                  imageAsset: 'assets/svg/ic_fat.svg',
                ),
                NutrientCardData(
                  label: 'Protein',
                  labelCategory: 'gr',
                  labelValue: widget.mealPlan.protein.toStringAsFixed(0),
                  imageAsset: 'assets/svg/ic_proteins.svg',
                ),
                NutrientCardData(
                  label: 'Total Kalori',
                  labelCategory: 'kcal',
                  labelValue: widget.mealPlan.calories.toStringAsFixed(0),
                  imageAsset: 'assets/svg/ic_fire.svg',
                ),
              ],
            ),

            MiddleContentMeal(mealPlanUuid: widget.mealPlan.uuid),
            // const BottomContentMeal()
          ],
        ),
      ),
      bottomNavigationBar: BottomContentMeal(
        mealPlan: widget.mealPlan,
      ),
    );
  }
}
