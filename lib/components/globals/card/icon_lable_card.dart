import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class IconLabelCard extends StatelessWidget {
  final String imageAsset;
  final String label;
  final double cardSize; // lebar & tinggi card (card square)
  final bool hasShadow;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color borderColor;
  final double imageSize;

  // Default color untuk gambar dan teks.
  final Color colorImageAndText;

  // Optional override untuk warna gambar dan teks secara terpisah.
  final Color? colorImage;
  final Color? colorText;

  const IconLabelCard({
    super.key,
    required this.imageAsset,
    required this.label,
    this.cardSize = 50.0,
    this.borderRadius = 16.0,
    this.hasShadow = false,
    this.onTap,
    this.borderColor = AppColors.base3,
    this.imageSize = 24.0,
    this.colorImageAndText = AppColors.primary1,
    this.colorImage,
    this.colorText,
  });

  // Jika colorImage tidak diberikan,
  // gunakan colorImageAndText sebagai fallback.
  Color get _imageColor => colorImage ?? colorImageAndText;

  // Jika colorText tidak diberikan,
  // gunakan colorImageAndText sebagai fallback.
  Color get _textColor => colorText ?? colorImageAndText;

  Widget _buildImage() {
    if (imageAsset.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        imageAsset,
        width: imageSize,
        height: imageSize,
        colorFilter: ColorFilter.mode(
          _imageColor,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        placeholderBuilder: (context) => const SizedBox(),
      );
    } else {
      return Image.asset(
        imageAsset,
        width: imageSize,
        height: imageSize,
        color: _imageColor,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: cardSize,
              height: cardSize,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.base5,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: hasShadow
                    ? [
                        BoxShadow(
                          color: AppColors.base1.withValues(alpha: 0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: _buildImage(),
            ),
            SizedBox(
              width: 70,
              height: 36,
              child: Text(
                label,
                style: AppTextStyles.lable3Medium(_textColor),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
