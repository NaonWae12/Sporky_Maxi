import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/secure_storage_service.dart';
import '../../models/components/meal_plan_cmp_mdl/meal_plan_model.dart';
import '../../views/meal_plan_page/meal_plan_page.dart';
import '../globals/card/meal_card.dart';
import '../globals/constants/api_endpoints.dart';

class CmpBottomMealPlan extends StatefulWidget {
  const CmpBottomMealPlan({super.key});

  @override
  State<CmpBottomMealPlan> createState() => _CmpBottomMealPlanState();
}

class _CmpBottomMealPlanState extends State<CmpBottomMealPlan> {
  List<MealPlan> _mealPlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealPlans();
  }

  Future<void> fetchMealPlans() async {
    try {
      final token = await SecureStorageService.getToken();
      debugPrint("🔑 Token saat ini: $token");
      if (token == null) {
        debugPrint("Token tidak ditemukan");
        setState(() => _isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.mealPlan),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> mealsJson = data['data'];

        setState(() {
          _mealPlans = mealsJson.map((e) => MealPlan.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        debugPrint(
            "Gagal memuat meal plan (${response.statusCode}): ${response.body}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching meal plans: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final int totalMealPlan = _mealPlans.length;

    // Tampilkan hanya 3 pertama
    List<MealPlan> displayedMealPlan =
        totalMealPlan > 3 ? _mealPlans.take(3).toList() : _mealPlans;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayedMealPlan.map((meal) {
            return MealCard(
              imagePath: meal.imageUrl,
              category: 'Sandwich, jeruk manis', // Hardcode dulu
              title: meal.uuid, // Sementara pakai uuid biar unik
              description: 'Menu spesial hari ini', // Hardcode dulu
              calories: meal.calories,
              categoryType: 'Makan Pagi', // Hardcode dulu
              onTap: () {
                // nanti bisa pake meal.id atau meal.uuid buat detail
                debugPrint('Tapped on ${meal.uuid}');
              },
            );
          }),
          if (totalMealPlan > 3)
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MealPlanPage()),
                  );
                },
                child: const Text('Lihat Semua'),
              ),
            ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
