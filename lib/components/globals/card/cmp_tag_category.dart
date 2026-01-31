import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class CmpTagCategory extends StatelessWidget {
  final String text;
  final String imageAsset;
  final TextStyle? textStyle;
  final double spacing;
  final Color? textColor;
  final Color? textAndImageColor;
  final TextOverflow? overflow;
  final double wrapText;
  final EdgeInsets padding;

  const CmpTagCategory({
    super.key,
    required this.text,
    required this.imageAsset,
    this.textStyle,
    this.spacing = 8,
    this.textColor,
    this.textAndImageColor,
    this.overflow,
    this.wrapText = 1.22,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    final bool isSvg = imageAsset.toLowerCase().endsWith('.svg');

    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSvg
                ? SvgPicture.asset(
                    colorFilter: textAndImageColor != null
                        ? ColorFilter.mode(textAndImageColor!, BlendMode.srcIn)
                        : null,
                    imageAsset,
                    height: 24,
                    width: 24,
                  )
                : Image.asset(
                    color: textAndImageColor,
                    imageAsset,
                    height: 24,
                    width: 24,
                  ),
            SizedBox(width: spacing),
            SizedBox(
              width: MediaQuery.of(context).size.width / wrapText,
              child: Text(
                text,
                style: textStyle ??
                    AppTextStyles.heading3SemiBold(textAndImageColor),
                overflow: overflow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
