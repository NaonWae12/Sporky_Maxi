import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../../models/components/meal_plan_cmp_mdl/nutrien_card_data.dart';
import '../../globals/card/globals_card.dart';
import '../../globals/card/globals_card_outlined.dart';

class TopContentMeal extends StatefulWidget {
  final String mealPlanUuid;
  final String? imageAsset; // tetap dipakai
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final int likes;
  final String? categories;
  final Color? colorChipMeal;
  final Color? colorChipKal;
  final String value;
  final List<NutrientCardData> nutrientCards;

  const TopContentMeal({
    super.key,
    required this.mealPlanUuid,
    this.imageAsset,
    required this.title,
    this.subtitle,
    this.onTap,
    required this.likes,
    required this.categories,
    this.colorChipMeal = AppColors.warn1,
    this.colorChipKal = AppColors.secondary2,
    required this.value,
    required this.nutrientCards,
  });

  @override
  State<TopContentMeal> createState() => _TopContentMealState();
}

class _TopContentMealState extends State<TopContentMeal> {
  bool isFavorited = false;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.likes;
    _checkInitialFavoriteStatus();
  }

  @override
  void didUpdateWidget(TopContentMeal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.likes != widget.likes) {
      setState(() {
        _likesCount = widget.likes;
      });
    }
  }

  Future<void> _checkInitialFavoriteStatus() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) return;
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(ApiEndpoints.mealPlanDetail(widget.mealPlanUuid)),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        // Cek di berbagai kemungkinan struktur response
        bool? isFav;
        final dataNode = decoded['data'];
        if (dataNode is Map<String, dynamic>) {
          // Struktur: data.meal_plan.is_favorite
          final mealPlan = dataNode['meal_plan'];
          if (mealPlan is Map<String, dynamic>) {
            isFav = mealPlan['is_favorite'] as bool?;
          }
          // Fallback: data.is_favorite
          isFav ??= dataNode['is_favorite'] as bool?;
        }
        if (isFav != null && mounted) {
          setState(() {
            isFavorited = isFav!;
          });
        } else {
          debugPrint(
              '[TopContentMeal] Field is_favorite tidak ditemukan, fallback ke favorites list');
          await _checkFavoriteFromList(authHeader);
        }
      }
    } catch (e) {
      debugPrint('[TopContentMeal] Error checking favorite status: $e');
    }
  }

  Future<void> _checkFavoriteFromList(String authHeader) async {
    try {
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
        if (dataNode is Map<String, dynamic>) {
          final mealPlansNode = dataNode['meal_plans'];
          if (mealPlansNode is List) {
            final isFav = mealPlansNode
                .whereType<Map<String, dynamic>>()
                .any((m) => m['uuid']?.toString() == widget.mealPlanUuid);
            if (mounted) {
              setState(() {
                isFavorited = isFav;
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[TopContentMeal] Error checking favorites list: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    final originalFavorited = isFavorited;
    final originalLikesCount = _likesCount;

    // Optimistic UI Update
    setState(() {
      isFavorited = !isFavorited;
      _likesCount = isFavorited ? _likesCount + 1 : _likesCount - 1;
    });

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            isFavorited = originalFavorited;
            _likesCount = originalLikesCount;
          });
        }
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.post(
        Uri.parse(ApiEndpoints.mealPlanFavorite(widget.mealPlanUuid)),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'];
        if (data != null) {
          final isFav = data['is_favorite'] as bool? ?? false;
          final totalFav =
              int.tryParse(data['total_favorites'].toString()) ?? 0;
          if (mounted) {
            setState(() {
              isFavorited = isFav;
              _likesCount = totalFav;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('[TopContentMeal] Error toggling favorite: $e');
    }

    // Revert if API call fails
    if (mounted) {
      setState(() {
        isFavorited = originalFavorited;
        _likesCount = originalLikesCount;
      });
    }
  }

  /// 🔥 helper image builder (asset + network)
  Widget _buildImage() {
    if (widget.imageAsset == null || widget.imageAsset!.isEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        color: AppColors.base3,
        child: const Icon(
          Icons.broken_image,
          size: 48,
          color: AppColors.base2,
        ),
      );
    }

    final bool isNetworkImage = widget.imageAsset!.startsWith('http');

    return isNetworkImage
        ? Image.network(
            widget.imageAsset!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                width: double.infinity,
                color: AppColors.base3,
                child: const Icon(
                  Icons.broken_image,
                  size: 48,
                  color: AppColors.base2,
                ),
              );
            },
          )
        : Image.asset(
            widget.imageAsset!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IMAGE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(),
          ),
        ),

        // CONTENT CARD
        GlobalsCard(
          backgroundColor: AppColors.base4,
          hasShadow: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CATEGORY + LIKES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GlobalsCardOutlined(
                          borderColor: Colors.transparent,
                          backgroundColor: widget.colorChipMeal!,
                          child: Row(
                            children: [
                              Text(
                                widget.categories ?? '-',
                                style: AppTextStyles.list3SemiBold(
                                  AppColors.base5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        GlobalsCardOutlined(
                          borderColor: Colors.transparent,
                          backgroundColor: widget.colorChipKal!,
                          child: Row(
                            children: [
                              Text(
                                widget.value,
                                style: AppTextStyles.list3SemiBold(
                                  AppColors.base5,
                                ),
                              ),
                              Text(
                                ' Kal',
                                style: AppTextStyles.list3SemiBold(
                                  AppColors.base5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 13,
                          color: AppColors.warn1,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_likesCount likes',
                          style: AppTextStyles.list3Regular(
                            AppColors.base1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // TITLE + FAVORITE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTextStyles.heading1SemiBold(),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.warn1,
                      ),
                    ),
                  ],
                ),

                if (widget.subtitle != null && widget.subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                    child: Text(
                      widget.subtitle!,
                      style: AppTextStyles.desc1Regular(AppColors.base1),
                    ),
                  ),

                // NUTRITION CARDS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: widget.nutrientCards.map((nutrient) {
                        return SizedBox(
                          height: 65,
                          width: 83,
                          child: GlobalsCard(
                            radius: 8,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            backgroundColor: AppColors.base5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: SvgPicture.asset(
                                    nutrient.imageAsset,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  nutrient.label,
                                  style: AppTextStyles.list3Regular(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      nutrient.labelValue,
                                      style: AppTextStyles.heading3SemiBold(),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      nutrient.labelCategory,
                                      style: AppTextStyles.heading3SemiBold(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
