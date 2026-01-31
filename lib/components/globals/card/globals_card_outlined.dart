import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class GlobalsCardOutlined extends StatelessWidget {
  final String? label;
  final String? value;
  final String? unit;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final String? text;
  final Widget? child;
  final TextStyle? textStyle;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const GlobalsCardOutlined({
    super.key,
    this.label,
    this.value,
    this.unit,
    this.borderColor = AppColors.secondary1,
    this.textColor = AppColors.secondary1,
    this.backgroundColor = AppColors.base5,
    this.text,
    this.child,
    this.textStyle,
    this.height = 22,
    this.width,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: borderRadius ?? BorderRadius.circular(30), // capsule
      ),
      child: child ??
          (text != null
              ? Text(text!,
                  style: textStyle ?? AppTextStyles.list1Regular(textColor))
              : (label != null && value != null && unit != null
                  ? RichText(
                      text: TextSpan(
                        style: textStyle ??
                            AppTextStyles.list1Regular(AppColors.base1),
                        children: [
                          TextSpan(text: '$label: '),
                          TextSpan(
                              text: value,
                              style: textStyle ??
                                  AppTextStyles.list1Bold(AppColors.base1)),
                          TextSpan(text: ' $unit'),
                        ],
                      ),
                    )
                  : const SizedBox())),
    );
  }
}
