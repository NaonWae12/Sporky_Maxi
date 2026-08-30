import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/meal_plan_cmp/cmp_card_list_article.dart';

import '../../../components/globals/card/globals_card_outlined.dart';
import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/constants/api_base_url.dart';
import '../../../components/globals/constants/api_endpoints.dart';
import '../../../components/globals/filter/filter_content_button.dart';
import '../../../components/globals/text/text_style.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../../models/components/meal_plan_cmp_mdl/meal_plan_model.dart';
import '../detail_meal_plan.dart';

/// Representasi satu entry card di list: satu MealPlan + satu displayType spesifik.
/// Digunakan untuk meng-expand meal plan multi-type menjadi beberapa card terpisah.
class _MealEntry {
  final MealPlan meal;
  final String displayType;

  const _MealEntry({required this.meal, required this.displayType});
}

class AllContentPage extends StatefulWidget {
  final String searchQuery;
  final String? category;

  const AllContentPage({super.key, this.searchQuery = '', this.category});

  @override
  State<AllContentPage> createState() => _AllContentPageState();
}

class _AllContentPageState extends State<AllContentPage> {
  List<String> _selectedFiltersFromBottomSheet = [];
  List<_MealEntry> _mealEntries = [];
  Map<String, int> _mealPlanLikes = {};
  bool _isLoading = true;
  List<Map<String, dynamic>> _structuredCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchMealPlans();
    _fetchIngredients();
  }

  /// Mengubah raw type string "makan_pagi" → "Makan Pagi"
  String _formatTypeLabel(String rawType) {
    return rawType
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  Future<void> _fetchIngredients() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        return;
      }
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(ApiEndpoints.mealPlanIngredients),
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final dataNode = decoded['data'];
        if (dataNode is Map<String, dynamic> &&
            dataNode['categories'] is List) {
          final List<dynamic> apiCats = dataNode['categories'];
          final List<Map<String, dynamic>> mapped = [];

          for (final apiCat in apiCats) {
            if (apiCat is! Map<String, dynamic>) continue;
            final label =
                apiCat['category_label']?.toString() ??
                apiCat['category']?.toString() ??
                '';
            final ingredientsList = apiCat['ingredients'];
            final List<String> itemNames = [];
            if (ingredientsList is List) {
              for (final ing in ingredientsList) {
                if (ing is Map<String, dynamic> && ing['name'] != null) {
                  itemNames.add(ing['name'].toString());
                }
              }
            }
            if (label.isNotEmpty && itemNames.isNotEmpty) {
              mapped.add({'title': label, 'items': itemNames});
            }
          }

          int totalIngredients = mapped.fold<int>(0, (sum, cat) {
            final items = cat['items'];
            return sum + (items is List ? items.length : 0);
          });
          debugPrint(
            '[AllContentPage] Filter categories fetched: ${mapped.length} categories, total ingredients: $totalIngredients',
          );

          if (mounted) {
            setState(() {
              _structuredCategories = mapped;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('[AllContentPage] Fetch ingredients error: $e');
    }
  }

  Future<void> _fetchMealPlans() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      // Build URI dengan query parameter untuk filter ingredients
      final uri = Uri.parse(ApiEndpoints.mealPlan);
      final finalUri = uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          'per_page': '9999',
          if (widget.category != null) 'category': widget.category!,
          if (_selectedFiltersFromBottomSheet.isNotEmpty)
            'ingredient[]': _selectedFiltersFromBottomSheet,
        },
      );

      final response = await http.get(
        finalUri,
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
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

        // ===== EXPAND: 1 MealPlan multi-type → beberapa _MealEntry =====
        final List<_MealEntry> entries = [];
        for (final meal in parsed) {
          if (meal.type.isEmpty) {
            entries.add(_MealEntry(meal: meal, displayType: 'Menu'));
          } else {
            for (final rawType in meal.type) {
              entries.add(
                _MealEntry(meal: meal, displayType: _formatTypeLabel(rawType)),
              );
            }
          }
        }

        debugPrint(
          '[AllContentPage] parsed: ${parsed.length} meal plans → ${entries.length} entries (setelah expand type)',
        );

        // Fetch likes count per-unique meal (bukan per-entry)
        final uniqueMeals = {
          for (final e in entries) e.meal.uuid: e.meal,
        }.values.toList();
        // Gunakan favorites_count yang sudah disertakan di response list API
        // (backend sudah menggunakan withCount) — tidak perlu N+1 request lagi.
        final Map<String, int> likesMap = {
          for (final meal in uniqueMeals) meal.uuid: meal.favoritesCount,
        };

        if (mounted) {
          setState(() {
            _mealEntries = entries;
            _mealPlanLikes = likesMap;
            _isLoading = false;
          });
        }
      } else {
        debugPrint('[AllContentPage] Gagal fetch (${response.statusCode})');
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('[AllContentPage] Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _normalizeImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return '${ApiBaseUrl.baseUrl}/$url';
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _mealEntries.where((entry) {
      if (widget.searchQuery.isEmpty) return true;
      return entry.meal.name.toLowerCase().contains(
        widget.searchQuery.toLowerCase(),
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _selectedFiltersFromBottomSheet.isNotEmpty
                      ? Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _selectedFiltersFromBottomSheet
                              .map(
                                (filter) => GlobalsCardOutlined(
                                  height: 24,
                                  borderColor: Colors.transparent,
                                  backgroundColor: AppColors.secondary2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        filter,
                                        style: AppTextStyles.list1Regular(
                                          AppColors.base5,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedFiltersFromBottomSheet
                                                .remove(filter);
                                            _isLoading = true;
                                          });
                                          _fetchMealPlans();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 12,
                                          color: AppColors.base5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const SizedBox(),
                ),
                const SizedBox(width: 8),
                FilterContentButton(
                  categories: const [],
                  structuredCategories: _structuredCategories,
                  initialSelected: _selectedFiltersFromBottomSheet,
                  title: 'Filter Bahan Makanan',
                  onFilterApplied: (selected) {
                    setState(() {
                      _selectedFiltersFromBottomSheet = selected;
                      _isLoading = true;
                    });
                    _fetchMealPlans();
                  },
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_mealEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'Belum ada menu tersedia.',
                  style: AppTextStyles.list1Regular(AppColors.base2),
                ),
              ),
            )
          else if (filteredEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'Tidak ada menu yang cocok dengan pencarian.',
                  style: AppTextStyles.list1Regular(AppColors.base2),
                ),
              ),
            )
          else
            ...filteredEntries.map((entry) {
              final imageUrl = _normalizeImageUrl(entry.meal.imageUrl);
              return CmpCardListArticle(
                imageAsset: imageUrl.isNotEmpty ? imageUrl : null,
                meal: entry.displayType,
                kal: entry.meal.calories.round(),
                title: entry.meal.name,
                description: entry.meal.subtitle.isNotEmpty
                    ? entry.meal.subtitle
                    : 'Menu pilihan bergizi untuk tumbuh kembang si kecil.',
                views: 0,
                likes: _mealPlanLikes[entry.meal.uuid] ?? 0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailMealPlan(mealPlan: entry.meal),
                    ),
                  );
                },
              );
            }),
        ],
      ),
    );
  }
}
