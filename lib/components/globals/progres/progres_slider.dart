import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class ProgressSlider extends StatelessWidget {
  final String label;
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final Color textColor;

  const ProgressSlider({
    super.key,
    required this.label,
    required this.percentage,
    this.activeColor = AppColors.secondary1,
    this.inactiveColor = AppColors.base3,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.textStyle,
    this.textColor = AppColors.secondary1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('*$label',
              style: textStyle ?? AppTextStyles.list3Regular(textColor)),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final clampedPercentage = percentage.clamp(0.0, 1.0);
              final thumbPosition = clampedPercentage * barWidth;

              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  const SizedBox(height: 26),
                  // Background bar
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: inactiveColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  // Active (filled) bar
                  FractionallySizedBox(
                    widthFactor: clampedPercentage,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  // Circle at the end of active bar
                  Positioned(
                    left: thumbPosition - 8, // center the circle
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.base4, width: 1.5)),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%', style: AppTextStyles.list1Regular(AppColors.base2)),
              Text('50%', style: AppTextStyles.list1Regular(AppColors.base2)),
              Text('100%', style: AppTextStyles.list1Regular(AppColors.base2)),
            ],
          ),
        ],
      ),
    );
  }
}
