import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class GlobalsButtonTransparent extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double width;
  final double height;
  final Color backgroundColor;
  final TextStyle textStyle;

  const GlobalsButtonTransparent({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor = AppColors.primary1,
    this.textColor = AppColors.primary1,
    this.width = double.infinity,
    this.height = 48.0,
    this.backgroundColor = Colors.transparent,
    this.textStyle = const TextStyle(), // Temporary placeholder
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle == const TextStyle()
              ? AppTextStyles.heading3SemiBold()
              : textStyle,
        ),
      ),
    );
  }
}
