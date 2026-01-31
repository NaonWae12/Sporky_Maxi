import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class DailyMissions extends StatelessWidget {
  final int missionCount;
  final List<MissionListItem> missions;

  const DailyMissions({
    super.key,
    this.missionCount = 0,
    required this.missions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/svg/ic_list.svg'),
              const SizedBox(width: 5),
              Text(
                'Misi Hari Ini',
                style: AppTextStyles.heading3SemiBold(AppColors.primary1),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '$missionCount/15 Tugas Harian Tersisa',
              style: AppTextStyles.list1Bold(AppColors.base2),
            ),
          ),
          const SizedBox(height: 4),
          ...missions.map(
            (item) => MissionListItem(
              iconAsset: item.iconAsset,
              label: item.label,
              iconColor: item.iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

class MissionListItem extends StatelessWidget {
  final String iconAsset;
  final Color iconColor;
  final String label;

  const MissionListItem({
    super.key,
    required this.iconAsset,
    required this.label,
    this.iconColor = AppColors.primary1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              height: 16,
              width: 16,
              iconAsset,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.list1Regular(AppColors.base1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width / 1.05,
          color: AppColors.primary3,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
