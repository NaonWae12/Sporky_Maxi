import 'package:flutter/material.dart';

import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class VideoCardItem extends StatelessWidget {
  final String? imageAsset;
  final List<String> categories;
  final int views;
  final int likes;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final double height;

  const VideoCardItem({
    super.key,
    this.imageAsset,
    required this.categories,
    required this.views,
    required this.likes,
    required this.title,
    required this.description,
    this.onTap,
    this.height = 348,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 343, maxHeight: height, maxWidth: 343, minHeight: 330),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onTap,
          child: GlobalsCardOutlined(
            borderRadius: BorderRadius.circular(16),
            backgroundColor: AppColors.base5,
            borderColor: AppColors.base3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar/video placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageAsset != null
                        ? Image.asset(
                            imageAsset!,
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
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kategori
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: categories
                            .map((cat) => GlobalsCardOutlined(
                                  text: cat,
                                  textStyle: AppTextStyles.lable4SemiRegular(
                                      AppColors.primary1),
                                  backgroundColor: AppColors.base5,
                                  borderColor: AppColors.primary1,
                                  textColor: AppColors.primary1,
                                  height: 16,
                                ))
                            .toList(),
                      ),
                      // Views & Likes
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye_outlined,
                              size: 13, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${views.toString()} views',
                              style:
                                  AppTextStyles.list3Regular(AppColors.base2)),
                          const SizedBox(width: 5),
                          const Icon(Icons.favorite,
                              size: 13, color: AppColors.warn1),
                          const SizedBox(width: 4),
                          Text('${likes.toString()} likes',
                              style:
                                  AppTextStyles.list3Regular(AppColors.base2)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 8),
                  // Judul
                  Text(
                    title,
                    style: AppTextStyles.heading2SemiBold(AppColors.base1),
                  ),
                  const SizedBox(height: 4),
                  // Deskripsi
                  Text(
                    description,
                    style: AppTextStyles.list1Regular(AppColors.base2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
