import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/dialog/badge_tooltip.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

class ShortBannerProfile extends StatelessWidget {
  final String childName;
  final int ageYear;
  final int ageMonth;
  final String status;
  final double width;
  final bool editButton;
  final VoidCallback? onEdit;
  final TooltipStep badgeTooltip;

  const ShortBannerProfile({
    super.key,
    required this.childName,
    required this.ageYear,
    required this.ageMonth,
    required this.status,
    this.width = 372,
    this.editButton = false,
    this.onEdit,
    this.badgeTooltip = TooltipStep.awal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GlobalsCard(
        backgroundColor: AppColors.primary3,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar anak
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary2,
                  backgroundImage: AssetImage('assets/temp_img/kids.png'),
                ),
                const SizedBox(width: 12),
                // Info Anak
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          childName,
                          style:
                              AppTextStyles.heading1SemiBold(AppColors.base1),
                        ),
                        const SizedBox(width: 5),
                        BadgeTooltip(
                          badgeTooltip,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.base1,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Umur: ',
                                  style: AppTextStyles.list1Regular(
                                      AppColors.base5),
                                ),
                                TextSpan(
                                  text: '$ageYear',
                                  style:
                                      AppTextStyles.list1Bold(AppColors.base5),
                                ),
                                TextSpan(
                                  text: ' thn ',
                                  style: AppTextStyles.list1Regular(
                                      AppColors.base5),
                                ),
                                TextSpan(
                                  text: '$ageMonth',
                                  style:
                                      AppTextStyles.list1Bold(AppColors.base5),
                                ),
                                TextSpan(
                                  text: ' bln',
                                  style: AppTextStyles.list1Regular(
                                      AppColors.base5),
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
                ),
                if (editButton)
                  GlobalsCard(
                      margin: const EdgeInsets.only(left: 32),
                      backgroundColor: AppColors.base5,
                      onTap: onEdit,
                      hasShadow: false,
                      padding: const EdgeInsets.all(7),
                      radius: 30,
                      child: SvgPicture.asset(
                          height: 20, width: 20, 'assets/svg/ic_edit.svg'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
