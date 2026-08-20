import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/meal_plan_cmp/cmp_card_list_article.dart';
import 'package:sporky_maxi/views/meal_plan_page/detail_meal_plan.dart';

import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/constants/api_base_url.dart';
import '../../../components/globals/constants/api_endpoints.dart';
import '../../../components/globals/text/text_style.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../../models/components/meal_plan_cmp_mdl/meal_plan_model.dart';
import '../../components/globals/form/search_input.dart';

class MealPlanFav extends StatefulWidget {
  const MealPlanFav({super.key});

  @override
  State<MealPlanFav> createState() => _MealPlanFavState();
}

class _MealPlanFavState extends State<MealPlanFav> {
  TextEditingController searchController = TextEditingController();
  List<MealPlan> _mealPlans = [];
  List<MealPlan> _filteredMealPlans = [];
  Map<String, int> _mealPlanLikes = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMealPlans();
  }

  Future<void> _fetchMealPlans() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(ApiEndpoints.mealPlanFavorites),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final dataNode = decoded['data'];
        List<dynamic> mealsRaw = [];

        if (dataNode is Map<String, dynamic>) {
          final mealPlansNode = dataNode['meal_plans'];
          if (mealPlansNode is List) mealsRaw = mealPlansNode;
        } else if (dataNode is List) {
          mealsRaw = dataNode;
        }

        final parsed = mealsRaw
            .whereType<Map<String, dynamic>>()
            .map(MealPlan.fromJson)
            .toList();

        final Map<String, int> likesMap = {};
        for (var mealJson in mealsRaw) {
          if (mealJson is Map<String, dynamic>) {
            final uuid = (mealJson['uuid'] ?? '').toString();
            final totalFavs = int.tryParse(mealJson['total_favorites']?.toString() ?? '') ?? 0;
            likesMap[uuid] = totalFavs;
          }
        }

        if (mounted) {
          setState(() {
            _mealPlans = parsed;
            _mealPlanLikes = likesMap;
            _isLoading = false;
            _filterMealPlans(_searchQuery);
          });
        }
      } else {
        debugPrint('[MealPlanFav] Gagal fetch (${response.statusCode})');
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('[MealPlanFav] Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterMealPlans(String query) {
    setState(() {
      _searchQuery = query;
      _filteredMealPlans = _mealPlans
          .where((meal) =>
              meal.name.toLowerCase().contains(query.toLowerCase()) ||
              meal.subtitle.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String _normalizeImageUrl(String imageUrl) {
    final url = imageUrl.trim();
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('assets/')) return url;
    if (url.startsWith('/')) return '${ApiBaseUrl.baseUrl}$url';
    return '${ApiBaseUrl.baseUrl}/$url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 5),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text(
              'Meal Plan Favorit',
              style: AppTextStyles.heading2SemiBold(),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchInput(
              showHeartIcon: false,
              hintText: 'brokoli pasta',
              controller: searchController,
              onHeartPressed: () {},
              onChanged: _filterMealPlans,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filteredMealPlans.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'Belum ada menu tersedia.',
                    style: AppTextStyles.list1Regular(AppColors.base2),
                  ),
                ),
              )
            else
              ..._filteredMealPlans.map((meal) {
                final imageUrl = _normalizeImageUrl(meal.imageUrl);
                return CmpCardListArticle(
                  imageAsset: imageUrl.isNotEmpty ? imageUrl : null,
                  meal: meal.displayType,
                  kal: meal.calories.round(),
                  title: meal.name,
                  description:
                      'Menu pilihan bergizi untuk tumbuh kembang si kecil.',
                  views: 0,
                  likes: _mealPlanLikes[meal.uuid] ?? 0,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMealPlan(mealPlan: meal),
                      ),
                    ).then((_) => _fetchMealPlans());
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}
