import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/profile_cmp/short_banner_profile.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../globals/dialog/badge_tooltip.dart';

class ProfileChildSection extends StatelessWidget {
  final String childName;
  final int ageYear;
  final int ageMonth;
  final String status;
  final double? width;

  final VoidCallback? onEdit;
  const ProfileChildSection({
    super.key,
    required this.childName,
    required this.ageYear,
    required this.ageMonth,
    required this.status,
    this.width,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              SvgPicture.asset('assets/svg/ic_bear_child.svg'),
              Text(
                'Profil Anak',
                style: AppTextStyles.heading3SemiBold(AppColors.primary1),
              )
            ],
          ),
        ),
        CmpTagAttention(
            imageAsset: 'assets/svg/ic_warn.svg',
            child: Text.rich(
                TextSpan(style: AppTextStyles.list1Regular(), children: [
              const TextSpan(text: 'Lihat dan'),
              TextSpan(
                  text: ' perbarui data anak',
                  style: AppTextStyles.list1Bold()),
              const TextSpan(text: 'sesuai pertumbuhan terbarunya.'),
            ]))),
        ShortBannerProfile(
          childName: childName,
          ageYear: ageYear,
          ageMonth: ageMonth,
          status: status,
          editButton: true,
          badgeTooltip: TooltipStep.lengkap,
          onEdit: onEdit,
        )
      ],
    );
  }
}
