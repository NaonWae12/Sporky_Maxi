import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

import '../text/text_style.dart';

class GlobalsTextArea extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double radius;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final double? width;

  const GlobalsTextArea({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.minLines = 4,
    this.maxLines = 8,
    this.fillColor = AppColors.base5,
    this.borderColor = AppColors.secondary1,
    this.focusedBorderColor = AppColors.primary1,
    this.radius = 12.0,
    this.onChanged,
    this.textStyle,
    this.labelStyle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        style: textStyle ?? AppTextStyles.headList1Regular(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: labelStyle ?? AppTextStyles.headList1Regular(),
          alignLabelWithHint: true,
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: borderColor!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: focusedBorderColor!, width: 1.5),
          ),
        ),
      ),
    );
  }
}
