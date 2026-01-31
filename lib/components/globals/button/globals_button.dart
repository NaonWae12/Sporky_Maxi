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
        ),
        onPressed: onPressed,
        child: child ??
            Text(
              text!,
              style:
                  customTextStyle ?? AppTextStyles.heading3SemiBold(textColor),
            ),
      ),
    );
  }
}
