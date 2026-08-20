import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/secure_storage_service.dart';
import '../../../core/services/child/eer_service.dart';
import '../../../core/services/child/screening_service.dart';
import '../../globals/button/food_portion_guide_button.dart';
import '../../globals/card/cmp_tag_category.dart';
import '../../globals/colors/colors.dart';
import '../../globals/constants/api_endpoints.dart';
import '../../globals/text/cms_html_cmp.dart';
import '../../globals/text/text_style.dart';
import '../../globals/text/html_normalization.dart';

class MiddleContentMeal extends StatefulWidget {
  const MiddleContentMeal({
    super.key,
    required this.mealPlanUuid,
  });

  final String mealPlanUuid;

  @override
  State<MiddleContentMeal> createState() => _MiddleContentMealState();
}

class _MiddleContentMealState extends State<MiddleContentMeal> {
  late Future<_MealPlanDetailContent> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _fetchMealPlanDetail();
  }

  Future<_MealPlanDetailContent> _fetchMealPlanDetail() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      return const _MealPlanDetailContent(
        recipe: '',
        tutorial: '',
        ingredients: [],
      );
    }

    int? calorieGroup;
    try {
      final childUuid = await SecureStorageService.getSelectedChildUuid();
      if (childUuid != null && childUuid.isNotEmpty) {
        final screeningData =
            await ScreeningService().getLatestByChildUuid(childUuid);
        final eer = screeningData.screening?.eer;
        final rawEer = eer == null ? 0 : EERService.roundToClosest(eer);
        calorieGroup = rawEer == 0 ? 2000 : rawEer;
        debugPrint(
            '[MiddleContentMeal] Selected child EER: $eer, calorie group: $calorieGroup');
      }
    } catch (e) {
      debugPrint('[MiddleContentMeal] Error fetching child screening/eer: $e');
    }

    final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
    final response = await http.get(
      Uri.parse(ApiEndpoints.mealPlanDetail(widget.mealPlanUuid)),
      headers: {
        'Authorization': authHeader,
        'Accept': 'application/json',
      },
    );

    // // PRINT FULL RESPONSE
    // debugPrint('========== MEAL PLAN DETAIL API ==========');
    // debugPrint('STATUS CODE: ${response.statusCode}');
    // debugPrint('URL: ${ApiEndpoints.mealPlanDetail(widget.mealPlanUuid)}');
    // debugPrint('BODY:');

    // const chunkSize = 1000;
    // for (var i = 0; i < response.body.length; i += chunkSize) {
    //   debugPrint(
    //     response.body.substring(
    //       i,
    //       i + chunkSize > response.body.length
    //           ? response.body.length
    //           : i + chunkSize,
    //     ),
    //   );
    // }

    // debugPrint('========== END RESPONSE ==========');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memuat detail meal plan (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final detail = _extractMealPlanDetail(decoded, widget.mealPlanUuid);

    return _MealPlanDetailContent(
      recipe: (detail['recipe']?.toString() ?? '').trim(),
      tutorial: (detail['tutorial']?.toString() ?? '').trim(),
      ingredients: detail['ingredients'] as List<dynamic>? ?? const [],
      calorieGroup: calorieGroup,
    );
  }

  Map<String, dynamic> _extractMealPlanDetail(
    Map<String, dynamic> decoded,
    String targetUuid,
  ) {
    final dataNode = decoded['data'];

    if (dataNode is Map<String, dynamic>) {
      // Struktur: data.meal_plan -> Map (single object)
      final mealPlanNode = dataNode['meal_plan'];
      if (mealPlanNode is Map<String, dynamic>) {
        return mealPlanNode;
      }

      // Struktur: data.meal_plans -> List
      final mealPlansNode = dataNode['meal_plans'];
      if (mealPlansNode is List) {
        final items = mealPlansNode.whereType<Map<String, dynamic>>();
        for (final item in items) {
          if ((item['uuid']?.toString() ?? '').trim() == targetUuid.trim()) {
            return item;
          }
        }
        if (items.isNotEmpty) return items.first;
      }

      // Fallback: data IS the meal plan object directly (has 'uuid' key)
      if (dataNode.containsKey('uuid')) {
        return dataNode;
      }
    }

    if (dataNode is List) {
      final items = dataNode.whereType<Map<String, dynamic>>();
      for (final item in items) {
        if ((item['uuid']?.toString() ?? '').trim() == targetUuid.trim()) {
          return item;
        }
      }
      if (items.isNotEmpty) return items.first;
    }

    return const <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_MealPlanDetailContent>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Gagal memuat detail resep.'),
          );
        }

        final detail = snapshot.data ??
            const _MealPlanDetailContent(
              recipe: '',
              tutorial: '',
            );

        return Column(
          children: [
            const CmpTagCategory(
              textAndImageColor: AppColors.primary1,
              text: 'Bahan - Bahan',
              imageAsset: 'assets/svg/ic_eat.svg',
            ),
            _DetailText(textData: HtmlNormalization.normalize(detail.recipe)),
            const CmpTagCategory(
              textAndImageColor: AppColors.primary1,
              text: 'Cara Membuat',
              imageAsset: 'assets/svg/bento-box-rounded.svg',
            ),
            _DetailText(
              textData: HtmlNormalization.normalize(
                detail.tutorial,
                orderedList: true,
              ),
            ),
            const CmpTagCategory(
              textAndImageColor: AppColors.primary1,
              text: 'takaran penyajian',
              imageAsset: 'assets/svg/bento-box-rounded.svg',
            ),
            _IngredientsTable(
              ingredients: detail.ingredients,
              calorieGroup: detail.calorieGroup,
            ),
            // tombol panduan
            FoodPortionGuideButton(
              showBanner: true,
            ),
            const CmpTagCategory(
              textAndImageColor: AppColors.primary1,
              text: 'Nilai Gizi & Manfaat',
              imageAsset: 'assets/svg/bento-box-rounded.svg',
            ),
          ],
        );
      },
    );
  }
}

class _DetailText extends StatelessWidget {
  final String textData;
  const _DetailText({
    required this.textData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 8),
      child: CmsHtmlContent(htmlData: textData),
    );
  }
}

class _MealPlanDetailContent {
  final String recipe;
  final String tutorial;
  final List<dynamic> ingredients;
  final int? calorieGroup;

  const _MealPlanDetailContent({
    required this.recipe,
    required this.tutorial,
    this.ingredients = const [],
    this.calorieGroup,
  });
}

/// Tabel transparan dua kolom untuk menampilkan takaran penyajian:
/// kolom kiri = nama bahan, kolom kanan = porsi.
class _IngredientsTable extends StatelessWidget {
  final List<dynamic> ingredients;
  final int? calorieGroup;

  const _IngredientsTable({
    required this.ingredients,
    this.calorieGroup,
  });

  String _resolvePortion(Map<String, dynamic> ingredientNode) {
    final portionsList = ingredientNode['portions'];
    if (portionsList is List && portionsList.isNotEmpty) {
      Map<String, dynamic>? matched;
      if (calorieGroup != null) {
        for (final p in portionsList) {
          if (p is Map<String, dynamic>) {
            final cg = p['calorie_group'];
            if (cg != null &&
                (cg is num ? cg.toInt() : int.tryParse(cg.toString())) ==
                    calorieGroup) {
              matched = p;
              break;
            }
          }
        }
      }
      matched ??= portionsList.whereType<Map<String, dynamic>>().firstOrNull;
      return matched?['portion']?.toString() ?? '';
    }
    return ingredientNode['portion']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('Data takaran penyajian belum tersedia.'),
      );
    }

    final rows = <Widget>[];

    for (final item in ingredients) {
      if (item is! Map<String, dynamic>) continue;
      final isHeader = item['is_header'] as bool? ?? false;

      if (isHeader) {
        final label = item['header_label']?.toString() ?? '';
        if (label.isNotEmpty) {
          // Spacer kalau bukan baris pertama
          if (rows.isNotEmpty) rows.add(const SizedBox(height: 8));
          rows.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                label,
                style: AppTextStyles.list3SemiBold(AppColors.secondary1),
              ),
            ),
          );
        }
        continue;
      }

      final ingredientNode = item['ingredient'];
      if (ingredientNode is! Map<String, dynamic>) continue;
      final name = ingredientNode['name']?.toString() ?? '';
      if (name.isEmpty) continue;
      final portion = _resolvePortion(ingredientNode);

      rows.add(_IngredientRow(
        name: name,
        portion: portion,
        isEven: rows.whereType<_IngredientRow>().length.isEven,
      ));
    }

    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('Data takaran penyajian belum tersedia.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header tabel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary1,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Bahan',
                    style: AppTextStyles.heading3SemiBold(AppColors.base5),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Porsi',
                    style: AppTextStyles.heading3SemiBold(AppColors.base5),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          // Baris-baris bahan
          ...rows,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String name;
  final String portion;
  final bool isEven;

  const _IngredientRow({
    required this.name,
    required this.portion,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isEven ? AppColors.base4 : AppColors.base5,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: AppTextStyles.list1Medium(AppColors.base1),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              portion.isNotEmpty ? portion : '-',
              style: AppTextStyles.list1Medium(AppColors.secondary1),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
