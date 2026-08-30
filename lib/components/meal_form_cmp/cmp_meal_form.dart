import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class DropdownItem {
  final String text;
  final String iconAsset;
  final Color? iconColor;

  DropdownItem({required this.text, required this.iconAsset, this.iconColor});
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

  void _toggleMealDropdown() {
    setState(() {
      final shouldExpand = !isExpanded1;
      isExpanded1 = shouldExpand;
      isExpanded2 = false;
    });
  }

  void _toggleCalorieMethodDropdown() {
    setState(() {
      final shouldExpand = !isExpanded2;
      isExpanded1 = false;
      isExpanded2 = shouldExpand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.base5,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.base4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle(
            'Waktu Makan',
            'Pilih kapan makanan ini dikonsumsi',
          ),
          const SizedBox(height: 8),
          _buildDropdownCard(
            selected: selectedMeal,
            placeholder: 'Pilih Jenis Makanan',
            fallbackIcon: 'assets/svg/bento-box-rounded.svg',
            isExpanded: isExpanded1,
            onTap: _toggleMealDropdown,
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
          _buildSectionTitle(
            'Metode Input',
            'Pilih cara menghitung kalori makanan',
          ),
          const SizedBox(height: 8),
          _buildDropdownCard(
            selected: selectedCalorieMethod,
            placeholder: 'Pilih Cara Menghitung Kalori',
            fallbackIcon: 'assets/svg/ic_form.svg',
            isExpanded: isExpanded2,
            onTap: _toggleCalorieMethodDropdown,
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
                  SvgPicture.asset('assets/svg/sun.svg', height: 11, width: 11),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _calorieItem(
              DropdownItem(text: 'QR Code', iconAsset: 'assets/svg/ic_ qr.svg'),
              enabled: false,
              child: Row(
                children: [
                  Text(
                    'QR Code',
                    style: AppTextStyles.headList1Regular(AppColors.base3),
                  ),
                  SvgPicture.asset(
                    'assets/svg/sun.svg',
                    height: 11,
                    width: 11,
                    colorFilter: const ColorFilter.mode(
                      AppColors.base3,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading3SemiBold(AppColors.secondary1),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: AppTextStyles.list1Regular(
            AppColors.base1.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownCard({
    required DropdownItem? selected,
    required String placeholder,
    required String fallbackIcon,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
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
            onTap: onTap,
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  SvgPicture.asset(
                    selected?.iconAsset ?? fallbackIcon,
                    colorFilter: selected?.iconColor != null
                        ? ColorFilter.mode(
                            selected!.iconColor!,
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selected?.text ?? placeholder,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading3Medium(
                        selected == null ? AppColors.base2 : AppColors.base1,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.secondary1,
                  ),
                ],
              ),
            ),
          ),
        ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.base4,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              item.iconAsset,
              colorFilter: ColorFilter.mode(
                item.iconColor ?? AppColors.base1,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.text,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading3Medium(AppColors.base1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// ITEM CARA HITUNG KALORI
  /// =======================
  Widget _calorieItem(DropdownItem item, {Widget? child, bool enabled = true}) {
    return GestureDetector(
      onTap: enabled
          ? () {
              setState(() {
                selectedCalorieMethod = item;
                isExpanded2 = false;
              });
              widget.onCalorieMethodChanged?.call(item);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.base4,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              item.iconAsset,
              colorFilter: ColorFilter.mode(
                enabled ? AppColors.base1 : AppColors.base3,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child:
                  child ??
                  Text(
                    item.text,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heading3Medium(
                      enabled ? AppColors.base1 : AppColors.base3,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
