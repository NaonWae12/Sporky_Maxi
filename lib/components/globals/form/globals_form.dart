import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class GlobalsForm extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isObscure;
  final bool hasShadow;
  final Color focusBorderColor;
  final Color enableBorderColor;
  final Color outlineInputBorderColor;
  final Color fillColor;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsets? contentPadding;
  final Widget? suffixIcon;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? cursorHeight;
  final Color labelColor;
  final double radius;
  final String? suffixSvgAsset;
  final double suffixIconSize;
  final Color? suffixIconColor;
  final Color? suffixIconFocusedColor;
  final BoxFit boxFit;
  final VoidCallback? onSuffix;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? hint;
  final bool enableFloatingLabel;

  const GlobalsForm({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscure = false,
    this.hasShadow = false,
    this.focusBorderColor = AppColors.primary1,
    this.enableBorderColor = AppColors.primary1,
    this.outlineInputBorderColor = AppColors.base3,
    this.fillColor = AppColors.base5,
    this.borderRadius,
    this.height,
    this.width,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.suffixIcon,
    this.padding,
    this.margin,
    this.cursorHeight,
    this.labelColor = Colors.grey,
    this.radius = 18,
    this.suffixSvgAsset,
    this.suffixIconSize = 20,
    this.suffixIconColor,
    this.suffixIconFocusedColor,
    this.boxFit = BoxFit.contain,
    this.onSuffix,
    this.readOnly = false,
    this.onTap,
    this.hint,
    this.enableFloatingLabel = true,
  });

  @override
  State<GlobalsForm> createState() => _GlobalsFormState();
}

class _GlobalsFormState extends State<GlobalsForm> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // Update UI saat fokus berubah
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return Container(
      margin: widget.margin,
      padding: widget.padding,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        boxShadow: widget.hasShadow
            ? [
                BoxShadow(
                  color:
                      AppColors.primary2.withValues(alpha: 0.2 * 255.round()),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: TextFormField(
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        focusNode: _focusNode,
        cursorHeight: widget.cursorHeight,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isObscure,
        style: widget.textStyle ?? AppTextStyles.heading3Medium(),
        decoration: InputDecoration(
          hint: !widget.enableFloatingLabel
              ? Text(
                  widget.label,
                  style: widget.hintStyle ??
                      widget.textStyle ??
                      AppTextStyles.heading3Medium(),
                )
              : widget.hint,
          suffixIcon:
              (widget.suffixIcon != null || widget.suffixSvgAsset != null)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.suffixIcon != null) widget.suffixIcon!,
                          if (widget.suffixSvgAsset != null)
                            GestureDetector(
                              onTap: widget.onSuffix,
                              child: SizedBox(
                                height: widget.suffixIconSize,
                                width: widget.suffixIconSize,
                                child: SvgPicture.asset(
                                  widget.suffixSvgAsset!,
                                  fit: widget.boxFit,
                                  colorFilter: ColorFilter.mode(
                                    isFocused
                                        ? (widget.suffixIconFocusedColor ??
                                            AppColors.primary1)
                                        : (widget.suffixIconColor ??
                                            AppColors.base2),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : null,
          labelText: widget.enableFloatingLabel ? widget.label : null,
          labelStyle: widget.labelStyle ??
              AppTextStyles.heading3Medium(widget.labelColor),
          filled: true,
          fillColor: widget.fillColor,
          floatingLabelStyle: AppTextStyles.heading3Medium(
            AppColors.primary1,
          ),
          floatingLabelBehavior: widget.enableFloatingLabel
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(19.5),
            borderSide: BorderSide(color: widget.focusBorderColor, width: 2),
          ),
          enabledBorder: isFocused
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19.5),
                  borderSide:
                      BorderSide(color: widget.enableBorderColor, width: 1.5),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19.5),
                  borderSide: BorderSide(
                      color: widget.outlineInputBorderColor, width: 1.2),
                ),
          contentPadding: widget.contentPadding,
        ),
      ),
    );
  }
}
