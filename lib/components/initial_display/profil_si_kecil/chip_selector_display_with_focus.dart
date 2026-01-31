import 'package:flutter/material.dart';
import '../../globals/card/globals_card_outlined.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/text_style.dart';

class ChipSelectorDisplayWithFocus extends StatefulWidget {
  // final String label;
  final List<String> selectedItems;
  final VoidCallback onTap;
  final double radius;
  final double borderWidth;
  final Color focusBorderColor;
  final Color enabledBorderColor;
  final Color backgroundColor;
  final EdgeInsets margin;
  final String hint;

  const ChipSelectorDisplayWithFocus(
      {super.key,
      // required this.label,
      required this.selectedItems,
      required this.onTap,
      this.radius = 19.5,
      this.borderWidth = 1.5,
      this.focusBorderColor = AppColors.primary1,
      this.enabledBorderColor = AppColors.base3,
      this.backgroundColor = AppColors.base5,
      this.margin = const EdgeInsets.symmetric(horizontal: 4),
      this.hint = "Pilih atau tambahkan manual"});

  @override
  State<ChipSelectorDisplayWithFocus> createState() =>
      _ChipSelectorDisplayWithFocusState();
}

class _ChipSelectorDisplayWithFocusState
    extends State<ChipSelectorDisplayWithFocus> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
        widget.onTap();
      },
      child: Focus(
        focusNode: _focusNode,
        child: AnimatedContainer(
          margin: widget.margin,
          width: double.infinity,
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: _isFocused
                  ? widget.focusBorderColor
                  : widget.enabledBorderColor,
              width: _isFocused ? 2 : widget.borderWidth,
            ),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   widget.label,
              //   style: AppTextStyles.heading3Medium(
              //     _isFocused
              //         ? widget.focusBorderColor
              //         : AppColors.base2, // label color
              //   ),
              // ),
              // const SizedBox(height: 8),
              widget.selectedItems.isEmpty
                  ? Text(
                      widget.hint,
                      style: TextStyle(color: AppColors.base3),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.selectedItems
                          .map(
                            (item) => GlobalsCardOutlined(
                              text: item,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item,
                                    style: AppTextStyles.lable3Regular(
                                      AppColors.secondary1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
