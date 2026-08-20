import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dialog/badge_tooltip.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../globals/card/globals_card.dart';
// import '../globals/dialog/info_tooltip_icon.dart';

class SubsPlanCmp extends StatelessWidget {
  final String price;
  final String periodLabel;
  final String desc;
  final String image;
  // final String descTooltip1;
  // final String descTooltip2;
  final String title;
  final List<FeatureTile> features;
  final Gradient? gradient;
  final Color backgroundColor;
  final Color lineColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color selectedBorderColor;
  final TooltipStep step;

  const SubsPlanCmp(
      {super.key,
      required this.price,
      required this.periodLabel,
      required this.desc,
      required this.image,
      // required this.descTooltip1,
      // required this.descTooltip2,
      required this.title,
      this.features = const [],
      this.gradient,
      this.backgroundColor = AppColors.base4,
      this.lineColor = AppColors.base2,
      this.isSelected = false,
      this.onTap,
      this.selectedBorderColor = AppColors.secondary1,
      required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlobalsCard(
          hasShadow: false,
          gradient: gradient,
          padding: const EdgeInsets.all(12),
          onTap: onTap,
          border: Border.all(
            color: isSelected ? selectedBorderColor : Colors.transparent,
            width: 2,
          ),
          backgroundColor: gradient == null ? backgroundColor : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    height: 20,
                    width: 20,
                  ),
                  Text(title, style: AppTextStyles.heading2SemiBold()),
                  const SizedBox(width: 5),
                  BadgeTooltip(useImageTrigger: false, step)
                  // InfoTooltipIcon(
                  //   image: image,
                  //   imageSize: 56,

                  //   content: SizedBox(
                  //     width: MediaQuery.of(context).size.width / 1.5,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(4.0),
                  //       child: Text.rich(
                  //         TextSpan(children: [
                  //           TextSpan(
                  //               text: '$descTooltip1 ',
                  //               style: AppTextStyles.list1Bold()),
                  //           TextSpan(
                  //               text: descTooltip2,
                  //               style: AppTextStyles.list1Regular())
                  //         ]),
                  //         overflow: TextOverflow.clip,
                  //         textAlign: TextAlign.justify,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Text(
                desc,
                style: AppTextStyles.lable3Medium(AppColors.base2),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("Rp${price}k",
                      style:
                          AppTextStyles.heading1SemiBold(AppColors.secondary2)),
                  const SizedBox(width: 3),
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        '/ $periodLabel',
                        style: AppTextStyles.lable3Medium(AppColors.base2),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width / 1.05,
                color: lineColor,
              ),
              const SizedBox(height: 8),
              FeatureTile(
                iconAsset: 'assets/svg/ic_ calendar - schedule.svg',
                text: periodLabel,
              ),
              ...features,
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String iconAsset;
  final String text;
  final double iconSize;
  final Color? iconColor;

  const FeatureTile({
    super.key,
    required this.iconAsset,
    required this.text,
    this.iconSize = 20,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: iconSize,
            height: iconSize,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                : null,
          ),
          const SizedBox(width: 6),
          Expanded(
            // biar teks wrap kalau panjang
            child: Text(
              text,
              style: AppTextStyles.headList1Regular(),
            ),
          ),
        ],
      ),
    );
  }
}
