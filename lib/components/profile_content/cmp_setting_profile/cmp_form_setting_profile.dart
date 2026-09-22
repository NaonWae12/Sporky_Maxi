import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';

class CmpFormSettingProfile extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String lable;
  final Color focusBorderColor;
  final Color enableBorderColor;
  final bool isObscure;
  final TextStyle? labelStyle;

  const CmpFormSettingProfile({
    super.key,
    required this.controller,
    required this.lable,
    required this.keyboardType,
    this.focusBorderColor = AppColors.primary2,
    this.enableBorderColor = Colors.transparent,
    this.isObscure = false,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsForm(
      hasShadow: false,
      fillColor: AppColors.base5,
      radius: 16,
      cursorHeight: 20,
      margin: const EdgeInsets.symmetric(vertical: 4),
      label: lable,
      labelStyle: labelStyle,
      labelColor: AppColors.base2,
      controller: controller,
      keyboardType: keyboardType,
      focusBorderColor: focusBorderColor,
      enableBorderColor: enableBorderColor,
      isObscure: isObscure,
    );
  }
}
