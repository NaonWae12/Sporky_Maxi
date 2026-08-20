import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals/card/cmp_tag_attention.dart';
import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class FoodWasteMealOption {
  final String text;
  final String iconAsset;
  final Color iconColor;

  const FoodWasteMealOption({
    required this.text,
    required this.iconAsset,
    required this.iconColor,
  });
}

class FirstFormCmp extends StatefulWidget {
  const FirstFormCmp({
    super.key,
    this.selectedMealOption,
    this.onMealOptionChanged,
  });

  final FoodWasteMealOption? selectedMealOption;
  final ValueChanged<FoodWasteMealOption>? onMealOptionChanged;

  @override
  State<FirstFormCmp> createState() => _FirstFormCmpState();
}

class _FirstFormCmpState extends State<FirstFormCmp> {
  bool isExpanded1 = false;
  FoodWasteMealOption? _selectedMealOption;

  static const List<FoodWasteMealOption> _mealOptions = [
    FoodWasteMealOption(
      text: 'Makan Pagi',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.primary1,
    ),
    FoodWasteMealOption(
      text: 'Snack Pagi',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.info1,
    ),
    FoodWasteMealOption(
      text: 'Makan Siang',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.warn1,
    ),
    FoodWasteMealOption(
      text: 'Snack Sore',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.info1,
    ),
    FoodWasteMealOption(
      text: 'Makan Malam',
      iconAsset: 'assets/svg/bento-box-rounded.svg',
      iconColor: AppColors.secondary1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMealOption = widget.selectedMealOption;
  }

  @override
  void didUpdateWidget(covariant FirstFormCmp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMealOption != oldWidget.selectedMealOption) {
      _selectedMealOption = widget.selectedMealOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isExpanded1 ? Radius.zero : const Radius.circular(12),
            bottomRight: isExpanded1 ? Radius.zero : const Radius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    _selectedMealOption?.iconAsset ??
                        'assets/svg/bento-box-rounded.svg',
                    colorFilter: _selectedMealOption != null
                        ? ColorFilter.mode(
                            _selectedMealOption!.iconColor,
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(_selectedMealOption?.text ?? 'Pilih Jenis Makanan',
                      style: AppTextStyles.headList1Regular()),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded1 = !isExpanded1;
                  });
                },
                icon: Icon(
                  isExpanded1
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              )
            ],
          ),
        ),
        if (isExpanded1) ...[
          for (var i = 0; i < _mealOptions.length; i++) ...[
            _mealOptionItem(_mealOptions[i]),
            if (i != _mealOptions.length - 1) const SizedBox(height: 8),
          ],
        ]
      ],
    );
  }

  Widget _mealOptionItem(FoodWasteMealOption option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMealOption = option;
          isExpanded1 = false;
        });
        widget.onMealOptionChanged?.call(option);
      },
      child: CmpTagAttention(
        space: 8,
        textStyle: AppTextStyles.headList1Regular(),
        imageAsset: option.iconAsset,
        text: option.text,
        lineColor: AppColors.base4,
        imageColor: option.iconColor,
      ),
    );
  }
}
