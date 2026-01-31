import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onHeartPressed;
  final VoidCallback? onLeadingPressed;
  final bool showHeartIcon;
  final String hintText;
  final bool showLeadingIcon;
  final Color leadingColor;
  final double leadingSize;
  final bool showChild;
  final Widget? child;

  const SearchInput({
    super.key,
    required this.controller,
    this.onHeartPressed,
    this.showHeartIcon = true,
    this.hintText = 'tumbuh kembang anak',
    this.showLeadingIcon = false,
    this.onLeadingPressed,
    this.leadingColor = AppColors.secondary1,
    this.leadingSize = 22,
    this.showChild = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLeadingIcon)
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: leadingColor,
                size: leadingSize,
              ),
              onPressed: onLeadingPressed,
            ),
          Expanded(
            child: SizedBox(
              height: 26,
              child: TextField(
                cursorHeight: 18,
                controller: controller,
                style: AppTextStyles.list1Regular(),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyles.list1Regular(AppColors.secondary2),
                  prefixIcon: SizedBox(
                    child: SvgPicture.asset(
                      'assets/svg/ic_ search.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.secondary2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.secondary2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.secondary2),
                  ),
                ),
              ),
            ),
          ),
          if (showHeartIcon)
            IconButton(
              icon: const Icon(
                Icons.favorite,
                color: AppColors.warn1,
              ),
              onPressed: onHeartPressed,
            ),
          if (showChild) SizedBox(child: child)
        ],
      ),
    );
  }
}
