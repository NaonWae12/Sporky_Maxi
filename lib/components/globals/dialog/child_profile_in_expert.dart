import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/profile_cmp/in_expert/child_profile_no_box.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import 'badge_tooltip.dart';

class ChildProfileInExpert extends StatelessWidget {
  final VoidCallback? onPressed;
  final String childName;
  final int ageMonth;
  final int ageYear;
  final String status;
  final String weight;
  final String height;
  final String medicalHistories;
  final String allergies;

  const ChildProfileInExpert({
    super.key,
    this.onPressed,
    required this.childName,
    required this.ageMonth,
    required this.ageYear,
    required this.status,
    required this.weight,
    required this.height,
    required this.medicalHistories,
    required this.allergies,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      backgroundColor: AppColors.base5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'X',
                style: AppTextStyles.heading3SemiBold(AppColors.base1),
              ),
            ),
          ),
          Text(
            'Profil Anak',
            style: AppTextStyles.headList1Bold(AppColors.base1),
          ),
          ChildProfileNoBox(
            isAsset: true,
            photoUrl: 'assets/temp_img/kids.png',
            childName: childName,
            ageMonth: ageMonth,
            ageYear: ageYear,
            status: status,
            step: TooltipStep.awal,
          ),
          Row(
            children: [
              Expanded(
                child: Card(title: 'Berat Badan (Kg)*', desc: weight),
              ),
              Expanded(
                child: Card(title: 'Tinggi Badan (cm)*', desc: height),
              ),
            ],
          ),
          Card(title: 'Riwayat Penyakit', desc: medicalHistories),
          Card(title: 'Alergi', desc: allergies),
          Card(
            title: 'Kegiatan Sehari - Hari [Hardcoded]',
            desc: 'Sekolah disertai kegiatan tambahan di dalam/luar sekolah',
          ),
          Card(
            title: 'Keluhan [Hardcoded]',
            desc:
                'Belakangan sering batuk saat malam hari dan pagi hari, ingin memastikan apakah perlu pemeriksaan lebih lanjut',
          ),
          GlobalsButton(
            width: MediaQuery.of(context).size.width / 1.3,
            elevation: 0,
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/ic_bear_child.svg',
                  colorFilter: ColorFilter.mode(
                    AppColors.base5,
                    BlendMode.srcIn,
                  ),
                ),
                Flexible(
                  child: GlobalsButtonText(
                    text: 'Lihat Profil Lengkap',
                    style: AppTextStyles.headList1Bold(AppColors.base5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String title;
  final String desc;
  const Card({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      backgroundColor: AppColors.base4,
      hasShadow: false,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.list3SemiBold(AppColors.base2)),
            Text(desc, style: AppTextStyles.headList1Regular(AppColors.base1)),
          ],
        ),
      ),
    );
  }
}
