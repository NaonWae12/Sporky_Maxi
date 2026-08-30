import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class CmpTagAttention extends StatelessWidget {
  final String? text;
  final String imageAsset;
  final TextStyle? textStyle;
  final double spacing;
  final Color? textColor;
  final Color? textAndImageColor;
  final double sizeImage;
  final Color imageColor;
  final Color lineColor;
  final double space;
  final bool line;
  final Widget? child;
  final double wrapText;
  final EdgeInsets padding;
  final int maxLines;

  const CmpTagAttention({
    super.key,
    this.text,
    required this.imageAsset,
    this.textStyle,
    this.spacing = 8,
    this.textColor,
    this.textAndImageColor,
    this.sizeImage = 16,
    this.imageColor = AppColors.primary1,
    this.lineColor = AppColors.primary2,
    this.space = 14,
    this.line = true,
    this.child,
    this.wrapText = 1.20,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSvg = imageAsset.toLowerCase().endsWith('.svg');

    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          final availableWidth = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : screenWidth - padding.horizontal;

          return Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isSvg
                        ? SvgPicture.asset(
                            colorFilter: ColorFilter.mode(
                              textAndImageColor ?? imageColor,
                              BlendMode.srcIn,
                            ),
                            imageAsset,
                            height: sizeImage,
                            width: sizeImage,
                          )
                        : Image.asset(
                            color: textAndImageColor ?? imageColor,
                            imageAsset,
                            height: sizeImage,
                            width: sizeImage,
                          ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: text != null
                          ? Text(
                              text!,
                              style:
                                  textStyle ??
                                  AppTextStyles.list1Regular(textAndImageColor),
                              maxLines: maxLines,
                              overflow: TextOverflow.ellipsis,
                            )
                          : child ?? const SizedBox.shrink(),
                    ),
                  ],
                ),
                SizedBox(height: space),
                if (line)
                  Container(height: 2, width: availableWidth, color: lineColor),
              ],
            ),
          );
        },
      ),
    );
  }
}
