import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_category.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../components/consultation_cmp/row_expert.dart';
import '../../components/consultation_cmp/row_rekomendation.dart';

class MainPageConsultation extends StatelessWidget {
  const MainPageConsultation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text(
              'Konsultasi',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            CmpTagAttention(
                text:
                    'Untuk mengajukan jadwal konsultasi, kamu perlu membeli tiket konsultasi terlebih dahulu. Setelah itu, kamu bisa memilih waktu dan dokter sesuai kebutuhan.',
                imageAsset: 'assets/svg/ic_warn.svg',
                imageColor: AppColors.info1,
                lineColor: AppColors.info1),
            CmpTagCategory(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                overflow: TextOverflow.clip,
                text: 'Expert Paling Banyak Dicari Saat Ini',
                imageAsset: 'assets/svg/ic_ rocket.svg',
                textAndImageColor: AppColors.warn1),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: RowExpert(),
            ),
            CmpTagCategory(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                overflow: TextOverflow.clip,
                text: 'Rekomendasi Berdasarkan Profil Anak',
                imageAsset: 'assets/svg/chart-fill-rounded.svg',
                textAndImageColor: AppColors.primary1),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: RowRekomendation(),
            ),
          ],
        ),
      ),
    );
  }
}
