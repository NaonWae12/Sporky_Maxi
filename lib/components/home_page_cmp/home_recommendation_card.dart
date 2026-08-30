import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class HomeRecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int likes;
  final IconData icon;
  final String placeholderLabel;
  final VoidCallback onTap;

  const HomeRecommendationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.likes,
    required this.icon,
    required this.placeholderLabel,
    required this.onTap,
  });

  bool get _isNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 226,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.base5,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.base4),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary1.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: SizedBox(
                height: 108,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary1.withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 14, color: AppColors.base5),
                            const SizedBox(width: 4),
                            Text(
                              '$likes likes',
                              style: AppTextStyles.lable3SemiBold(
                                AppColors.base5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.list1Bold(AppColors.base1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.list3Regular(AppColors.base2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl.isEmpty) return _placeholder();

    if (_isNetworkImage) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _placeholder(isLoading: true);
        },
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder({bool isLoading = false}) {
    return Container(
      color: AppColors.base4,
      child: Center(
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.image_rounded,
                    color: AppColors.base2,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    placeholderLabel,
                    style: AppTextStyles.lable3SemiBold(AppColors.base2),
                  ),
                ],
              ),
      ),
    );
  }
}
