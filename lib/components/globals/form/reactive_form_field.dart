// belum digunakan
import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

class ReactiveFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isObscure;
  final bool hasShadow;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final TextStyle? labelStyle;
  final EdgeInsets? contentPadding;
  final Widget? suffixIcon;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? cursorHeight;
  final double radius;

  // Trigger external highlight state
  final bool isHighlighted;

  const ReactiveFormField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isObscure = false,
    this.hasShadow = false,
    this.fillColor,
    this.borderRadius,
    this.height,
    this.width,
    this.labelStyle,
    this.contentPadding,
    this.suffixIcon,
    this.padding,
    this.margin,
    this.cursorHeight,
    this.radius = 18,
    this.isHighlighted = false,
  });

  @override
  State<ReactiveFormField> createState() => _ReactiveFormFieldState();
}

class _ReactiveFormFieldState extends State<ReactiveFormField> {
  late FocusNode _focusNode;
  late Color _fillColor;
  late Color _focusBorderColor;
  late Color _labelColor;

  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _fillColor = widget.fillColor ?? AppColors.base5;
    _focusBorderColor =
        widget.isHighlighted ? AppColors.base2 : AppColors.primary1;
    _labelColor = widget.isHighlighted ? AppColors.base2 : AppColors.primary1;

    _focusNode.addListener(() {
      setState(() {}); // Update UI saat focus berubah
    });

    widget.controller.addListener(() {
      if (!_hasChanged && widget.controller.text.isNotEmpty) {
        setState(() {
          _hasChanged = true;
          _fillColor = AppColors.base5;
          _focusBorderColor = AppColors.primary1;
          _labelColor = AppColors.primary1;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ReactiveFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // kalau trigger dari luar berubah dan belum diubah user
    if (widget.isHighlighted != oldWidget.isHighlighted && !_hasChanged) {
      setState(() {
        _focusBorderColor =
            widget.isHighlighted ? AppColors.base2 : AppColors.primary1;
        _labelColor =
            widget.isHighlighted ? AppColors.base2 : AppColors.primary1;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalsForm(
      controller: widget.controller,
      label: widget.label,
      keyboardType: widget.keyboardType,
      isObscure: widget.isObscure,
      hasShadow: widget.hasShadow,
      fillColor: _fillColor,
      focusBorderColor: _focusBorderColor,
      enableBorderColor: _focusBorderColor,
      borderRadius: widget.borderRadius,
      height: widget.height,
      width: widget.width,
      labelStyle: widget.labelStyle,
      contentPadding: widget.contentPadding,
      suffixIcon: widget.suffixIcon,
      padding: widget.padding,
      margin: widget.margin,
      cursorHeight: widget.cursorHeight,
      labelColor: _labelColor,
      radius: widget.radius,
    );
  }
}
