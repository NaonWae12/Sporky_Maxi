import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import '../../globals/colors/colors.dart';
import '../../globals/dialog/badge_tooltip.dart';
import '../../globals/text/text_style.dart';

class ChildProfileCmp extends StatelessWidget {
  final String? imageAsset;
  final String chatQouta;
  final String zoomQuota;
  final String zScore;
  final TooltipStep badge;
  final String childName;
  final VoidCallback? onTap;

  const ChildProfileCmp({
    super.key,
    this.imageAsset,
    this.chatQouta = '',
    this.zoomQuota = '',
    this.zScore = '',
    this.badge = TooltipStep.awal,
    required this.childName,
    this.onTap,
  });

  Color getBadgeColor() {
    switch (badge) {
      case TooltipStep.awal:
        return AppColors.info1;
      case TooltipStep.pertama:
        return AppColors.primary1;
      case TooltipStep.pasti:
        return AppColors.base2;
      case TooltipStep.hebat:
        return AppColors.warn1;
      case TooltipStep.lengkap:
        return AppColors.primary2;
    }
  }

  String getBadgeText(TooltipStep step) {
    switch (step) {
      case TooltipStep.awal:
        return 'Langkah Awal';
      case TooltipStep.pertama:
        return 'Langkah Pertama';
      case TooltipStep.pasti:
        return 'Langkah Pasti';
      case TooltipStep.hebat:
        return 'Langkah Hebat';
      case TooltipStep.lengkap:
        return 'Paket Lengkap';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> infoItems = [
      {
        'icon': 'assets/svg/chat-rounded.svg',
        'text': '${chatQouta}x Konsultasi Chat',
      },
      {
        'icon': 'assets/svg/ic_ video call.svg',
        'text': '${zoomQuota}x Konsultasi Zoom',
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageAsset != null
                ? Image.asset(
                    imageAsset!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.base3,
                    child: const Icon(Icons.broken_image,
                        size: 48, color: AppColors.base2),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        GlobalsCard(
          hasShadow: false,
          backgroundColor: AppColors.base4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalsCardOutlined(
                    borderColor: getBadgeColor(),
                    height: 24,
                    backgroundColor: AppColors.base5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Row(
                        children: [
                          BadgeTooltip(
                            badge,
                            imageSize: 24,
                            useImageTrigger: true,
                            stepIconSize: 16,
                          ),
                          Text(
                            getBadgeText(badge),
                            style: AppTextStyles.list3SemiBold(getBadgeColor()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                childName,
                style: AppTextStyles.heading1SemiBold(),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: infoItems.map((item) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2.38,
                    child: GlobalsCard(
                      margin: const EdgeInsets.all(0),
                      radius: 8,
                      hasShadow: false,
                      height: 30,
                      backgroundColor: AppColors.base5,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            item['icon']!,
                            height: 13,
                            width: 13,
                            colorFilter: const ColorFilter.mode(
                                AppColors.base1, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['text']!,
                            style: AppTextStyles.list1Regular(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              GlobalsCard(
                onTap: onTap,
                margin: const EdgeInsets.all(0),
                height: 30,
                radius: 8,
                hasShadow: false,
                backgroundColor: AppColors.base5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/svg/ic_ growth.svg',
                          height: 13,
                          width: 13,
                          colorFilter: const ColorFilter.mode(
                              AppColors.base1, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Z-Score : $zScore',
                          style: AppTextStyles.list1Regular(),
                        )
                      ],
                    ),
                    const Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }
}
