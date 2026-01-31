import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/card_lable_meal_plan.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';

import '../globals/card/globals_card_outlined.dart';
import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class CmpCardListArticle extends StatelessWidget {
  final String? imageAsset;

  final int views;
  final int likes;
  final String title;

  final String description;
  final VoidCallback? onTap;
  final String meal;
  final int kal;

  const CmpCardListArticle({
    super.key,
    this.imageAsset,
    required this.views,
    required this.likes,
    required this.title,
    required this.description,
    this.onTap,
    required this.meal,
    required this.kal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlobalsCard(
            hasShadow: false,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar/video placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageAsset != null
                      ? Image.asset(
                          imageAsset!,
                          height: 88,
                          width: 68,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 88,
                          width: 68,
                          color: AppColors.base3,
                          child: const Icon(Icons.broken_image,
                              size: 28, color: AppColors.base2),
                        ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori
                      Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CardLableMealPlan(categoryType: meal),
                                const SizedBox(width: 5),
                                GlobalsCardOutlined(
                                  height: 16,
                                  backgroundColor: AppColors.secondary2,
                                  text: '$kal kal',
                                  textStyle: AppTextStyles.list3Regular(
                                      AppColors.base5),
                                  borderColor: Colors.transparent,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.favorite,
                                    size: 13, color: AppColors.warn1),
                                const SizedBox(width: 4),
                                Text('${likes.toString()} likes',
                                    style: AppTextStyles.list3Regular(
                                        AppColors.base2)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Text(title,
                          style: AppTextStyles.list1Bold(AppColors.base1)),

                      // Deskripsi
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.56,
                        child: Text(
                          description,
                          style: AppTextStyles.list3Regular(AppColors.base2),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
        Container(
          color: AppColors.base3,
          height: 1,
          width: MediaQuery.of(context).size.width / 1.10,
        )
      ],
    );
  }
}
