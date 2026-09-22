import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  void _toggleMealDropdown() {
    setState(() {
      isExpanded1 = !isExpanded1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Column(
        children: [
          _buildDropdownCard(),
          if (isExpanded1) ...[
            const SizedBox(height: 8),
            for (var i = 0; i < _mealOptions.length; i++) ...[
              _mealOptionItem(_mealOptions[i]),
              if (i != _mealOptions.length - 1) const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildDropdownCard() {
    final selected = _selectedMealOption;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.base5,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected == null ? AppColors.base3 : AppColors.primary1,
          width: selected == null ? 1.2 : 1.5,
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleMealDropdown,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              SvgPicture.asset(
                selected?.iconAsset ?? 'assets/svg/bento-box-rounded.svg',
                colorFilter: selected == null
                    ? null
                    : ColorFilter.mode(selected.iconColor, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  selected?.text ?? 'Pilih Jenis Makanan',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading3Medium(
                    selected == null ? AppColors.base2 : AppColors.base1,
                  ),
                ),
              ),
              Icon(
                isExpanded1
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.secondary1,
              ),
            ],
          ),
        ),
      ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.base4,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              option.iconAsset,
              colorFilter: ColorFilter.mode(option.iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                option.text,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading3Medium(AppColors.base1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
