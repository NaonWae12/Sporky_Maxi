import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';

class CmpFormSettingProfile extends StatefulWidget {
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
  State<CmpFormSettingProfile> createState() => _CmpFormSettingProfileState();
}

class _CmpFormSettingProfileState extends State<CmpFormSettingProfile> {
  late Color currentFillColor;

  @override
  void initState() {
    super.initState();

    // Default fillColor saat kosong
    currentFillColor = AppColors.base3;

    // Listen ke perubahan teks
    widget.controller.addListener(() {
      final isFilled = widget.controller.text.trim().isNotEmpty;

      setState(() {
        currentFillColor = isFilled ? AppColors.base5 : AppColors.base3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalsForm(
      hasShadow: false,
      fillColor: currentFillColor,
      radius: 16,
      cursorHeight: 20,
      margin: const EdgeInsets.symmetric(vertical: 4),
      label: widget.lable,
      labelStyle: widget.labelStyle,
      labelColor: AppColors.base2,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      focusBorderColor: widget.focusBorderColor,
      enableBorderColor: widget.enableBorderColor,
      isObscure: widget.isObscure,
    );
  }
}
