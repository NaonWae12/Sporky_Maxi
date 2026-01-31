import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../models/components/meal_plan_cmp_mdl/nutrien_card_data.dart';
import '../../globals/card/globals_card.dart';
import '../../globals/card/globals_card_outlined.dart';

class TopContentMeal extends StatefulWidget {
  final String? imageAsset;
  final String title;
  final VoidCallback? onTap;
  final int likes;
  final String? categories;
  final Color? colorChipMeal;
  final Color? colorChipKal;
  final String value;
  final List<NutrientCardData> nutrientCards;

  const TopContentMeal({
    super.key,
    this.imageAsset,
    required this.title,
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // gambar/video
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.imageAsset != null
                ? Image.asset(
                    widget.imageAsset!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.base3,
                    child: const Icon(Icons.broken_image,
                        size: 48, color: AppColors.base2),
                  ),
          ),
        ),

        // container terpisah
        GlobalsCard(
            backgroundColor: AppColors.base4,
            hasShadow: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kategori
                      Row(
                        children: [
                          GlobalsCardOutlined(
                            borderColor: Colors.transparent,
                            backgroundColor: widget.colorChipMeal!,
                            child: Row(
                              children: [
                                Text(
                                  widget.categories!,
                                  style: AppTextStyles.list3SemiBold(
                                      AppColors.base5),
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
                                      AppColors.base5),
                                ),
                                Text(' Kal',
                                    style: AppTextStyles.list3SemiBold(
                                        AppColors.base5))
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Likes
                      Row(
                        children: [
                          const Icon(Icons.favorite,
                              size: 13, color: AppColors.warn1),
                          const SizedBox(width: 4),
                          Text('${widget.likes.toString()} likes',
                              style:
                                  AppTextStyles.list3Regular(AppColors.base1)),
                        ],
                      ),
                    ],
                  ),
                  // Judul
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.heading1SemiBold(),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorited = !isFavorited;
                            });
                          },
                          icon: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.warn1,
                          ))
                    ],
                  ),
                  // disini konten card dinamis

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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
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
                                        )),
                                    const SizedBox(height: 4),
                                    Text(nutrient.label,
                                        style: AppTextStyles.list3Regular()),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(nutrient.labelValue,
                                            style: AppTextStyles
                                                .heading3SemiBold()),
                                        const SizedBox(width: 2),
                                        Text(nutrient.labelCategory,
                                            style: AppTextStyles
                                                .heading3SemiBold()),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ))
      ],
    );
  }
}
