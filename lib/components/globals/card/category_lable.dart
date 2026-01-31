import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class CategoryLabel extends StatelessWidget {
  final String title;
  final double? height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final String? imageAsset;
  final double imageSize;
  final Color imageColor;

  const CategoryLabel({
    super.key,
    required this.title,
    this.height,
    this.backgroundColor = AppColors.primary1,
    this.textColor = AppColors.base5,
    this.borderRadius = 15.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    this.imageAsset,
    this.imageSize = 24.0,
    this.imageColor = AppColors.base5,
  });

  Widget? _buildImage() {
    if (imageAsset?.isNotEmpty != true) return null;

    if (imageAsset!.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        imageAsset!,
        width: imageSize,
        height: imageSize,
        colorFilter: ColorFilter.mode(imageColor, BlendMode.srcIn),
        fit: BoxFit.contain,
        placeholderBuilder: (context) => const SizedBox(),
      );
    } else {
      return Image.asset(
        imageAsset!,
        color: imageColor,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _buildImage();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: Row(
            children: [
              if (imageWidget != null) ...[
                imageWidget,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(title,
                    style: AppTextStyles.heading3SemiBold(AppColors.base5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
