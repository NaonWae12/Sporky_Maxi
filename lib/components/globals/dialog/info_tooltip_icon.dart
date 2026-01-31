import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class InfoTooltipIcon extends StatelessWidget {
  const InfoTooltipIcon({
    super.key,
    required this.image,
    this.padding = const EdgeInsets.all(4),
    this.imageSize,
    this.child,
    this.content,
    this.useImageTrigger = false,
    this.stepIconSize,
  });

  final String image;
  final double? imageSize;
  final Widget? child;
  final Widget? content;
  final bool useImageTrigger;
  final double? stepIconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Widget defaultTrigger = Container(
      padding: padding,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.base5,
      ),
      child: useImageTrigger
          ? SvgPicture.asset(
              image,
              height: stepIconSize ?? 24,
              width: stepIconSize ?? 24,
            )
          : Text(
              '?',
              style: AppTextStyles.lable2Regular(AppColors.base2),
            ),
    );

    return Tooltip(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColors.base5),
      richMessage: WidgetSpan(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              image,
              height: imageSize,
              width: imageSize,
            ),
            SizedBox(
              child: content,
            )
          ],
        ),
      ),
      child: child ?? defaultTrigger,
    );
  }
}
