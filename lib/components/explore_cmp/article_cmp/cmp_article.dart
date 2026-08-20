import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';

import '../../globals/card/globals_card_outlined.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/text_style.dart';

class CmpArticle extends StatelessWidget {
  final String? imageAsset;
  final List<String> categories;
  final int views;
  final int likes;
  final String title;
  final String doctor;
  final String description;
  final VoidCallback? onTap;

  const CmpArticle({
    super.key,
    this.imageAsset,
    required this.categories,
    required this.views,
    required this.likes,
    required this.title,
    required this.doctor,
    required this.description,
    this.onTap,
  });

  bool _isNetworkImage(String imagePath) {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  Widget _buildImage() {
    final imagePath = imageAsset?.trim();
    if (imagePath == null || imagePath.isEmpty) {
      return _placeholder();
    }

    if (_isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        height: 88,
        width: 120,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: 88,
            width: 120,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return Image.asset(
      imagePath,
      height: 88,
      width: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 88,
      width: 120,
      color: AppColors.base3,
      child: const Icon(Icons.broken_image, size: 28, color: AppColors.base2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GlobalsCard(
          hasShadow: false,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          child: Row(
            children: [
              // Gambar/video placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImage(),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.58,
                    child: Text(
                      title,
                      style: AppTextStyles.list1Bold(AppColors.base1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.circle,
                          size: 13, color: AppColors.base2),
                      const SizedBox(width: 4),
                      Text('${doctor.toString()} ',
                          style: AppTextStyles.list3Regular(AppColors.base2)),
                      const SizedBox(width: 5),
                      const Icon(Icons.remove_red_eye_outlined,
                          size: 13, color: AppColors.base2),
                      const SizedBox(width: 4),
                      Text('${views.toString()} views',
                          style: AppTextStyles.list3Regular(AppColors.base2)),
                      const SizedBox(width: 5),
                      const Icon(Icons.favorite,
                          size: 13, color: AppColors.warn1),
                      const SizedBox(width: 4),
                      Text('${likes.toString()} likes',
                          style: AppTextStyles.list3Regular(AppColors.base2)),
                    ],
                  ),
                  // Deskripsi
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.58,
                    child: Text(
                      description,
                      style: AppTextStyles.list3Regular(AppColors.base2),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
