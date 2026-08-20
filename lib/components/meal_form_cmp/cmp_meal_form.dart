import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class DropdownItem {
  final String text;
  final String iconAsset;
  final Color? iconColor;

  DropdownItem({
    required this.text,
    required this.iconAsset,
    this.iconColor,
  });
}

class CmpMealForm extends StatefulWidget {
  const CmpMealForm({
    super.key,
    this.selectedMeal,
    this.selectedCalorieMethod,
    this.onMealChanged,
    this.onCalorieMethodChanged,
  });

  final DropdownItem? selectedMeal;
  final DropdownItem? selectedCalorieMethod;
  final ValueChanged<DropdownItem>? onMealChanged;
  final ValueChanged<DropdownItem>? onCalorieMethodChanged;

  @override
  State<CmpMealForm> createState() => _CmpMealFormState();
}

class _CmpMealFormState extends State<CmpMealForm> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;

  DropdownItem? selectedMeal;
  DropdownItem? selectedCalorieMethod;

  @override
  void initState() {
    super.initState();
    selectedMeal = widget.selectedMeal;
    selectedCalorieMethod = widget.selectedCalorieMethod;
  }

  @override
  void didUpdateWidget(covariant CmpMealForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMeal != oldWidget.selectedMeal) {
      selectedMeal = widget.selectedMeal;
    }
    if (widget.selectedCalorieMethod != oldWidget.selectedCalorieMethod) {
      selectedCalorieMethod = widget.selectedCalorieMethod;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// =======================
        /// DROPDOWN JENIS MAKANAN
        /// =======================
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
                    selectedMeal?.iconAsset ??
                        'assets/svg/bento-box-rounded.svg',
                    colorFilter: selectedMeal?.iconColor != null
                        ? ColorFilter.mode(
                            selectedMeal!.iconColor!,
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedMeal?.text ?? 'Pilih Jenis Makanan',
                    style: AppTextStyles.headList1Regular(),
                  ),
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
          _mealItem(
            DropdownItem(
              text: 'Makan Pagi',
              iconAsset: 'assets/svg/bento-box-rounded.svg',
              iconColor: AppColors.primary1,
            ),
          ),
          const SizedBox(height: 8),
          _mealItem(
            DropdownItem(
              text: 'Snack Pagi',
              iconAsset: 'assets/svg/bento-box-rounded.svg',
              iconColor: AppColors.info1,
            ),
          ),
          const SizedBox(height: 8),
          _mealItem(
            DropdownItem(
              text: 'Makan Siang',
              iconAsset: 'assets/svg/bento-box-rounded.svg',
              iconColor: AppColors.warn1,
            ),
          ),
          const SizedBox(height: 8),
          _mealItem(
            DropdownItem(
              text: 'Snack Sore',
              iconAsset: 'assets/svg/bento-box-rounded.svg',
              iconColor: AppColors.info1,
            ),
          ),
          const SizedBox(height: 8),
          _mealItem(
            DropdownItem(
              text: 'Makan Malam',
              iconAsset: 'assets/svg/bento-box-rounded.svg',
              iconColor: AppColors.secondary1,
            ),
          ),
        ],

        const SizedBox(height: 16),

        /// =======================
        /// DROPDOWN CARA HITUNG KALORI
        /// =======================
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isExpanded2 ? Radius.zero : const Radius.circular(12),
            bottomRight: isExpanded2 ? Radius.zero : const Radius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    selectedCalorieMethod?.iconAsset ??
                        'assets/svg/ic_form.svg',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedCalorieMethod?.text ??
                        'Pilih Cara Menghitung Kalori',
                    style: AppTextStyles.headList1Regular(),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded2 = !isExpanded2;
                  });
                },
                icon: Icon(
                  isExpanded2
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              )
            ],
          ),
        ),

        if (isExpanded2) ...[
          _calorieItem(
            DropdownItem(
              text: 'Isi Manual',
              iconAsset: 'assets/svg/ic_edit.svg',
            ),
          ),
          const SizedBox(height: 8),
          _calorieItem(
            DropdownItem(
              text: 'Meal Plan (Auto Filled)',
              iconAsset: 'assets/svg/bento-box-rounded.svg',
            ),
            child: Row(
              children: [
                Text(
                  'Meal Plan (Auto Filled)',
                  style: AppTextStyles.headList1Regular(),
                ),
                SvgPicture.asset(
                  'assets/svg/sun.svg',
                  height: 11,
                  width: 11,
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          _calorieItem(
            DropdownItem(
              text: 'QR Code',
              iconAsset: 'assets/svg/ic_ qr.svg',
            ),
            child: Row(
              children: [
                Text(
                  'QR Code',
                  style: AppTextStyles.headList1Regular(),
                ),
                SvgPicture.asset(
                  'assets/svg/sun.svg',
                  height: 11,
                  width: 11,
                )
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// =======================
  /// ITEM JENIS MAKANAN
  /// =======================
  Widget _mealItem(DropdownItem item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeal = item;
          isExpanded1 = false;
        });
        widget.onMealChanged?.call(item);
      },
      child: CmpTagAttention(
        space: 8,
        textStyle: AppTextStyles.headList1Regular(),
        imageAsset: item.iconAsset,
        text: item.text,
        lineColor: AppColors.base4,
        imageColor: item.iconColor ?? AppColors.base1,
      ),
    );
  }

  /// =======================
  /// ITEM CARA HITUNG KALORI
  /// =======================
  Widget _calorieItem(
    DropdownItem item, {
    Widget? child,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCalorieMethod = item;
          isExpanded2 = false;
        });
        widget.onCalorieMethodChanged?.call(item);
      },
      child: CmpTagAttention(
        space: 8,
        imageAsset: item.iconAsset,
        lineColor: AppColors.base4,
        textAndImageColor: AppColors.base1,
        text: child == null ? item.text : null,
        child: child,
      ),
    );
  }
}
