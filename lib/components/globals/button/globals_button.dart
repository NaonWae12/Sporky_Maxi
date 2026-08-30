import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../colors/colors.dart';

class GlobalsButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double elevation;
  final TextStyle? customTextStyle;
  final Widget? child;
  final double radius;

  const GlobalsButton({
    super.key,
    this.text,
    required this.onPressed,
    this.color = AppColors.primary1,
    this.textColor = AppColors.base5,
    this.width = double.infinity,
    this.height = 48,
    this.elevation = 2,
    this.customTextStyle,
    this.child,
    this.radius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: elevation,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          minimumSize: const Size(0, 48),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
        onPressed: onPressed,
        child:
            child ??
            GlobalsButtonText(
              text: text!,
              style:
                  customTextStyle ?? AppTextStyles.heading3SemiBold(textColor),
            ),
      ),
    );
  }
}

class GlobalsButtonText extends StatelessWidget {
  const GlobalsButtonText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          text,
          textAlign: textAlign,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          textScaler: TextScaler.linear(_scaleForWidth(constraints.maxWidth)),
          style: style.copyWith(height: 1.05),
        );
      },
    );
  }

  double _scaleForWidth(double width) {
    if (width >= 180 || text.length <= 14) return 1;
    if (width >= 140 || text.length <= 20) return 0.92;
    if (width >= 110 || text.length <= 26) return 0.84;
    return 0.76;
  }
}
