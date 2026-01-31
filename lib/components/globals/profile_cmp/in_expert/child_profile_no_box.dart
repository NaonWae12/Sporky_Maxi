import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../colors/colors.dart';
import '../../dialog/badge_tooltip.dart';

class ChildProfileNoBox extends StatelessWidget {
  final String? photoUrl;
  final bool isAsset;
  final String childName;
  final int ageYear;
  final int ageMonth;
  final String status;
  final TooltipStep step;
  final VoidCallback? onTap;
  const ChildProfileNoBox({
    super.key,
    this.photoUrl,
    this.isAsset = false,
    required this.childName,
    required this.ageYear,
    required this.ageMonth,
    required this.status,
    required this.step,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      onTap: onTap,
      hasShadow: false,
      backgroundColor: AppColors.base5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 56,
                height: 56,
                child: photoUrl != null
                    ? Image(
                        image: isAsset
                            ? AssetImage(photoUrl!) as ImageProvider
                            : NetworkImage(photoUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.base2,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.base2,
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(childName,
                        style: AppTextStyles.heading1SemiBold(AppColors.base1)),
                    const SizedBox(width: 5),
                    BadgeTooltip(
                      useImageTrigger: true,
                      step,
                      stepIconSize: 15,
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary1,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Umur: ',
                              style:
                                  AppTextStyles.list1Regular(AppColors.base5),
                            ),
                            TextSpan(
                              text: '$ageYear',
                              style: AppTextStyles.list1Bold(AppColors.base5),
                            ),
                            TextSpan(
                              text: ' thn ',
                              style:
                                  AppTextStyles.list1Regular(AppColors.base5),
                            ),
                            TextSpan(
                              text: '$ageMonth',
                              style: AppTextStyles.list1Bold(AppColors.base5),
                            ),
                            TextSpan(
                              text: ' bln',
                              style:
                                  AppTextStyles.list1Regular(AppColors.base5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary1,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: AppTextStyles.list1Bold(AppColors.base5),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
