import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ReactiveGlobalsDropdown<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final Color focusBorderColor;
  final Color enableBorderColor;
  final Color fillColor;
  final BorderRadius? borderRadius;
  final bool hasShadow;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets contentPadding;
  final double radius;
  final TextStyle? labelStyle;
  final Color labelColor;

  const ReactiveGlobalsDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.focusBorderColor = AppColors.primary1,
    this.enableBorderColor = AppColors.primary1,
    this.fillColor = AppColors.base5,
    this.borderRadius,
    this.hasShadow = false,
    this.margin,
    this.padding,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.radius = 18,
    this.labelStyle,
    this.labelColor = Colors.grey,
  });

  @override
  State<ReactiveGlobalsDropdown<T>> createState() =>
      _ReactiveGlobalsDropdownState<T>();
}

class _ReactiveGlobalsDropdownState<T>
    extends State<ReactiveGlobalsDropdown<T>> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // Trigger rebuild untuk perubahan focus
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
      decoration: BoxDecoration(
        boxShadow: widget.hasShadow
            ? [
                BoxShadow(
                  color: AppColors.primary2.withAlpha(150),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: DropdownButtonFormField<T>(
        focusNode: _focusNode,
        value: widget.value,
        items: widget.items,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        onChanged: widget.onChanged,
        style: AppTextStyles.heading3Medium(),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: widget.labelStyle ??
              AppTextStyles.heading3Medium(widget.labelColor),
          filled: true,
          fillColor: widget.fillColor,
          floatingLabelStyle: AppTextStyles.heading3Medium(AppColors.primary1),
          contentPadding: widget.contentPadding,
          enabledBorder: isFocused
              ? OutlineInputBorder(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(19.5),
                  borderSide:
                      BorderSide(color: widget.enableBorderColor, width: 1.5),
                )
              : OutlineInputBorder(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(19.5),
                  borderSide:
                      const BorderSide(color: AppColors.base3, width: 1.2),
                ),
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(19.5),
            borderSide: BorderSide(color: widget.focusBorderColor, width: 2),
          ),
        ),
      ),
    );
  }
}
