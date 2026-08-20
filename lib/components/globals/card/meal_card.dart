import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../colors/colors.dart';
import '../dialog/dialog_alert.dart';
import '../text/text_style.dart';
import 'card_lable_meal_plan.dart';

class MealCard extends StatefulWidget {
  final String imagePath;
  final String category;
  final String title;
  final String description;
  final double calories;
  final String categoryType;
  final VoidCallback onTap;
  final bool isSporkyPlus;
  final String? mealPlanUuid;
  final bool initialIsFavorite;

  const MealCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.description,
    required this.calories,
    required this.categoryType,
    required this.onTap,
    this.isSporkyPlus = false,
    this.mealPlanUuid,
    this.initialIsFavorite = false,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.initialIsFavorite;
    _checkInitialFavoriteStatus();
  }

  @override
  void didUpdateWidget(MealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsFavorite != widget.initialIsFavorite) {
      setState(() {
        _isFavorited = widget.initialIsFavorite;
      });
    }
  }

  Future<void> _checkInitialFavoriteStatus() async {
    if (widget.mealPlanUuid == null) return;
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) return;
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';

      // Gunakan favorites list karena GET /favorite/{uuid} tidak tersedia di BE
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
                _isFavorited = isFav;
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[MealCard] Error checking favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (widget.mealPlanUuid == null) return;

    final originalFav = _isFavorited;
    setState(() {
      _isFavorited = !_isFavorited;
    });

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isFavorited = originalFav;
        });
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.post(
        Uri.parse(ApiEndpoints.mealPlanFavorite(widget.mealPlanUuid!)),
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
          if (mounted) {
            setState(() {
              _isFavorited = isFav;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('[MealCard] Error toggling favorite: $e');
    }

    if (mounted) {
      setState(() {
        _isFavorited = originalFav;
      });
    }
  }

  Color get _buttonColor {
    final cat = widget.categoryType.trim().toLowerCase();
    if (cat.contains('snack')) {
      return AppColors.warn4;
    }
    return AppColors.success2;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (widget.isSporkyPlus) {
            DialogAlert.show(
              barrierDismissible: true,
              context: context,
              title: "Buka Akses Tanpa Batas ",
              message:
                  "Beberapa fitur hanya tersedia untuk paket lengkap. Yuk, upgrade paket agar si Kecil bisa tumbuh lebih optimal! 🌱",
            );
          } else {
            widget.onTap();
          }
        },
        child: Stack(
          children: [
            Opacity(
              opacity: widget.isSporkyPlus ? 0.5 : 1.0,
              child: Container(
                width: 140,
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: _buildImage(widget.imagePath),
                          ),

                          // Label atas
                          Positioned(
                            top: 6,
                            left: 4,
                            child: CardLableMealPlan(
                                categoryType: widget.categoryType),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Judul
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    widget.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.lable3SemiBold(
                                        AppColors.base1),
                                  ),
                                ),
                                // Deskripsi
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    widget.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.list3Regular(
                                        AppColors.base1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          // Kalori
                          Container(
                            width: 45,
                            height: 27,
                            decoration: BoxDecoration(
                              color: AppColors.secondary1,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.calories.toStringAsFixed(0)} ',
                                  style:
                                      AppTextStyles.list1Bold(AppColors.base5),
                                ),
                                Text(
                                  "kal",
                                  style: AppTextStyles.list3Regular(
                                      AppColors.base5),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      // tombol Meal plan
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GlobalsButton(
                          color: _buttonColor,
                          onPressed: _toggleFavorite,
                          height: 22,
                          child: Row(
                            children: [
                              Icon(
                                _isFavorited
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 14,
                                color: AppColors.base5,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Meal Plan',
                                style: AppTextStyles.list1Bold(),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (widget.isSporkyPlus)
              Positioned(
                top: 90,
                left: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary1,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.base1.withAlpha(120),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: AppColors.base5),
                      const SizedBox(width: 5),
                      Text(
                        "Buka dengan Sporky +",
                        style: AppTextStyles.list3SemiBold(AppColors.base5),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _buildImage(String imagePath) {
  final bool isNetworkImage = imagePath.startsWith('http');

  return isNetworkImage
      ? Image.network(
          imagePath,
          width: 138,
          height: 170,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 138,
              height: 170,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Gambar gagal dimuat → tampilkan ikon broken image
            return Container(
              width: 138,
              height: 170,
              color: Colors.grey[200],
              child: const Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey,
              ),
            );
          },
        )
      : Image.asset(
          imagePath,
          width: 138,
          height: 170,
          fit: BoxFit.cover,
        );
}
