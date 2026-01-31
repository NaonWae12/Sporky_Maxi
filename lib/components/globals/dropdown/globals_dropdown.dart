import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class GlobalsDropdown<T> extends StatelessWidget {
  final String hintText;
  final Color? hinTextColor;
  final T? value;
  final List<T> items;
  final Color? itemsColor;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabelBuilder;
  final Color backgroundColor;
  final double radius;
  final EdgeInsets padding;
  final TextStyle? textStyleValue;
  final TextStyle? textStyleItems;
  final double height;
  final double? width;
  final Color borderColor;

  const GlobalsDropdown(
      {super.key,
      required this.hintText,
      this.hinTextColor,
      required this.value,
      required this.items,
      this.itemsColor,
      required this.onChanged,
      required this.itemLabelBuilder,
      this.backgroundColor = AppColors.base5,
      this.radius = 12.0,
      this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      this.textStyleValue,
      this.textStyleItems,
      this.height = 42,
      this.width,
      this.borderColor = AppColors.secondary1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hintText,
            style:
                textStyleValue ?? AppTextStyles.headList1Regular(hinTextColor),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabelBuilder(item),
                  style: textStyleItems ??
                      AppTextStyles.headList1Regular(itemsColor)),
            );
          }).toList(),
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
