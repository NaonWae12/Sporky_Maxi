import 'package:flutter/material.dart';

import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class VideoCardItem extends StatelessWidget {
  final String? mediaUrl; // 👈 ganti jadi fleksibel
  final List<String> categories;
  final int views;
  final int likes;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final double height;

  const VideoCardItem({
    super.key,
    this.mediaUrl,
    required this.categories,
    required this.views,
    required this.likes,
    required this.title,
    required this.description,
    this.onTap,
    this.height = 448,
  });

  bool get _isNetwork => mediaUrl != null && mediaUrl!.startsWith('http');

  bool get _isVideo =>
      mediaUrl != null &&
      (mediaUrl!.endsWith('.mp4') || mediaUrl!.contains('video'));

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 343,
        maxHeight: 700,
        maxWidth: 443,
        minHeight: 354,
      ),
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
                  /// 🔥 MEDIA (IMAGE / VIDEO)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildMedia(),
                  ),

                  const SizedBox(height: 8),

                  /// 🔥 CATEGORY + META
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: categories
                            .map(
                              (cat) => GlobalsCardOutlined(
                                text: cat,
                                textStyle: AppTextStyles.lable4SemiRegular(
                                    AppColors.primary1),
                                backgroundColor: AppColors.base5,
                                borderColor: AppColors.primary1,
                                textColor: AppColors.primary1,
                                height: 16,
                              ),
                            )
                            .toList(),
                      ),
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye_outlined,
                              size: 13, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '$views views',
                            style: AppTextStyles.list3Regular(AppColors.base2),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.favorite,
                              size: 13, color: AppColors.warn1),
                          const SizedBox(width: 4),
                          Text(
                            '$likes likes',
                            style: AppTextStyles.list3Regular(AppColors.base2),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// 🔥 TITLE
                  Text(
                    title,
                    style: AppTextStyles.heading2SemiBold(AppColors.base1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  /// 🔥 DESCRIPTION
                  Text(
                    description,
                    style: AppTextStyles.list1Regular(AppColors.base2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 MEDIA BUILDER
  Widget _buildMedia() {
    if (mediaUrl == null) {
      return _placeholder();
    }

    Widget imageWidget;

    if (_isNetwork) {
      imageWidget = Image.network(
        mediaUrl!,
        height: 205,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            height: 205,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _placeholder();
        },
      );
    } else {
      imageWidget = Image.asset(
        mediaUrl!,
        height: 205,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    /// 🔥 Kalau video → kasih icon play overlay
    if (_isVideo) {
      return Stack(
        alignment: Alignment.center,
        children: [
          imageWidget,
          const Icon(
            Icons.play_circle_fill,
            size: 50,
            color: Colors.white,
          ),
        ],
      );
    }

    return imageWidget;
  }

  /// 🔥 PLACEHOLDER
  Widget _placeholder() {
    return Container(
      height: 205,
      width: double.infinity,
      color: AppColors.base3,
      child: const Icon(
        Icons.broken_image,
        size: 48,
        color: AppColors.base2,
      ),
    );
  }
}
