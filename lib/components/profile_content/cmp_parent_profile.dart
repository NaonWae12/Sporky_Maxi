import 'package:flutter/material.dart';

import 'package:sporky_maxi/components/profile_content/cmp_parent_profile/profile_parent_section.dart';
import 'package:sporky_maxi/components/profile_content/cmp_parent_profile/progres_section.dart';

import '../../views/profile/page_setting_profile/page_setting_child_profile.dart';
import '../globals/colors/colors.dart';
import 'cmp_parent_profile/daily_missions.dart';
import 'cmp_parent_profile/information_center.dart';
import 'cmp_parent_profile/packages_and_coupons.dart';
import 'cmp_parent_profile/profile_child_section.dart';

class CmpParentProfile extends StatelessWidget {
  final String name;
  final int? countNotif;
  final String badgeImg;
  final VoidCallback directToEditPage;

  const CmpParentProfile({
    super.key,
    required this.directToEditPage,
    required this.name,
    this.countNotif,
    required this.badgeImg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileParentSection(
            directToEditPage: directToEditPage,
            name: name,
            countNotif: countNotif),
        // progress content
        ProgresSection(
          badgeImg: badgeImg,
        ),
        const DailyMissions(
          missionCount: 3,
          missions: [
            MissionListItem(
              iconAsset: 'assets/svg/ic_ growth.svg',
              label: 'Update tumbuh kembang harian Kiara',
            ),
            MissionListItem(
              iconAsset: 'assets/svg/bento-box-rounded.svg',
              label: 'Isi form meal plan harian Kiara: Sarapan',
            ),
            MissionListItem(
              iconAsset: 'assets/svg/bento-box-rounded.svg',
              label: 'Isi form meal plan harian Kiara: Makan Siang',
              iconColor: AppColors.warn1,
            ),
          ],
        ),
        ProfileChildSection(
          childName: 'Kiara Alicia',
          ageMonth: 8,
          ageYear: 1,
          status: 'Normal',
          onEdit: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageSettingChildProfile(),
                ));
          },
        ),
        const PackagesAndCouponsList(data: [
          {
            'title': 'Langkah Untuk Masa Depan',
            'name': 'Kiara Alicia',
            'badgeImg': 'assets/svg/sun.svg',
            'validUntil': '31 Juni 2026',
            'expertGroup': true,
          },
          {
            'title': 'Konsultasi Hebat',
            'name': 'Rafa Pratama',
            'badgeImg': 'assets/svg/ic_ doctor.svg',
            'validUntil': '15 Agustus 2026',
            'expertGroup': false,
            'imageColor': AppColors.base1
          },
          {
            'title': 'Langkah Untuk Masa Depan',
            'name': 'Kiara Alicia',
            'badgeImg': 'assets/svg/sun.svg',
            'validUntil': '31 Juni 2026',
            'expertGroup': true,
          },
        ]),
        const InformationCenter()
      ],
    );
  }
}
