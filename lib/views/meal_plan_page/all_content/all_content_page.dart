import 'dart:async';
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
  static const int _perPage = 10;
  static const Duration _searchDebounceDuration = Duration(milliseconds: 350);

  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  List<String> _selectedFiltersFromBottomSheet = [];
  List<_MealEntry> _mealEntries = [];
  Map<String, int> _mealPlanLikes = {};
  bool _isLoading = true;
  bool _isLoadingMore = false;
  Object? _error;
  int _currentPage = 0;
  int _lastPage = 1;
  List<Map<String, dynamic>> _structuredCategories = [];

  bool get _hasMore => _currentPage < _lastPage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchMealPlans(reset: true);
    _fetchIngredients();
  }

  @override
  void didUpdateWidget(covariant AllContentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.category != widget.category) {
      _searchDebounce?.cancel();
      _searchDebounce = Timer(_searchDebounceDuration, () {
        if (mounted) _reloadMealPlans();
      });
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter > 240) return;
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    _loadMoreMealPlans();
  }

  void _reloadMealPlans() {
    setState(() {
      _isLoading = true;
      _isLoadingMore = false;
      _error = null;
    });
    _fetchMealPlans(reset: true);
  }

  void _loadMoreMealPlans() {
    setState(() {
      _isLoadingMore = true;
      _error = null;
    });
    _fetchMealPlans(reset: false);
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

  Future<void> _fetchMealPlans({required bool reset}) async {
    final page = reset ? 1 : _currentPage + 1;

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isLoadingMore = false;
          });
        }
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      // Load dibatasi per halaman; backend sudah menyediakan pagination.
      final uri = Uri.parse(ApiEndpoints.mealPlan);
      final search = widget.searchQuery.trim();
      final finalUri = uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          'page': page.toString(),
          'per_page': _perPage.toString(),
          if (search.isNotEmpty) 'search': search,
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
        var currentPage = page;
        var lastPage = reset ? 1 : _lastPage;

        if (dataNode is Map<String, dynamic>) {
          final mealPlansNode = dataNode['meal_plans'];
          if (mealPlansNode is List) mealsRaw = mealPlansNode;

          final paginationNode = dataNode['pagination'];
          if (paginationNode is Map<String, dynamic>) {
            currentPage = _toInt(paginationNode['current_page'], page);
            lastPage = _toInt(paginationNode['last_page'], currentPage);
          }
        } else if (dataNode is List) {
          mealsRaw = dataNode;
        }

        final parsed = mealsRaw
            .whereType<Map<String, dynamic>>()
            .map(MealPlan.fromJson)
            .toList();
        final entries = _expandMealEntries(parsed);

        debugPrint(
          '[AllContentPage] page $currentPage/$lastPage: ${parsed.length} meal plans → ${entries.length} entries',
        );

        final uniqueMeals = {
          for (final e in entries) e.meal.uuid: e.meal,
        }.values.toList();
        final Map<String, int> likesMap = {
          for (final meal in uniqueMeals) meal.uuid: meal.favoritesCount,
        };

        if (mounted) {
          setState(() {
            _mealEntries = reset ? entries : [..._mealEntries, ...entries];
            _mealPlanLikes = reset
                ? likesMap
                : {..._mealPlanLikes, ...likesMap};
            _currentPage = currentPage;
            _lastPage = lastPage;
            _isLoading = false;
            _isLoadingMore = false;
            _error = null;
          });
        }
      } else {
        debugPrint('[AllContentPage] Gagal fetch (${response.statusCode})');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isLoadingMore = false;
            _error = response.statusCode;
          });
        }
      }
    } catch (e) {
      debugPrint('[AllContentPage] Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _error = e;
        });
      }
    }
  }

  List<_MealEntry> _expandMealEntries(List<MealPlan> meals) {
    final List<_MealEntry> entries = [];
    for (final meal in meals) {
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
    return entries;
  }

  int _toInt(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
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
    return Column(
      children: [
        _buildFilterHeader(),
        Expanded(child: _buildMealPlanBody()),
      ],
    );
  }

  Widget _buildFilterHeader() {
    return Padding(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                      _selectedFiltersFromBottomSheet.remove(
                                        filter,
                                      );
                                      _isLoading = true;
                                    });
                                    _fetchMealPlans(reset: true);
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
              _fetchMealPlans(reset: true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _mealEntries.isEmpty) {
      return Center(
        child: TextButton(
          onPressed: _reloadMealPlans,
          child: const Text('Gagal memuat menu. Coba lagi'),
        ),
      );
    }

    if (_mealEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            widget.searchQuery.trim().isEmpty
                ? 'Belum ada menu tersedia.'
                : 'Tidak ada menu yang cocok dengan pencarian.',
            style: AppTextStyles.list1Regular(AppColors.base2),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _mealEntries.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _mealEntries.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final entry = _mealEntries[index];
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
                builder: (context) => DetailMealPlan(mealPlan: entry.meal),
              ),
            );
          },
        );
      },
    );
  }
}
