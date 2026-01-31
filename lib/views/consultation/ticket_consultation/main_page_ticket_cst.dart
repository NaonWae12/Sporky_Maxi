import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

import '../../../components/consultation_cmp/ticket_consultation_cmp/finish.dart';
import '../../../components/consultation_cmp/ticket_consultation_cmp/not_yet.dart';
import '../../../components/consultation_cmp/ticket_consultation_cmp/schedule.dart';
import '../../../components/globals/bar/full_width_tab_bar.dart';
import '../../../components/globals/text/text_style.dart';

class MainPageTicketCst extends StatelessWidget {
  const MainPageTicketCst({super.key});

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
              'Tiket Konsultasi',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          const CmpTagAttention(
            text:
                'Bunda bisa mulai konsultasi sekarang jika expert tersedia, atau atur jadwal di waktu yang paling nyaman. Jangan khawatir, tiket berlaku selama 30 hari setelah pembelian.',
            imageAsset: 'assets/svg/ic_warn.svg',
            imageColor: AppColors.info1,
            lineColor: AppColors.info1,
            space: 10,
          ),
          const SizedBox(height: 8),
          Expanded(
              child: FullWidthTabBar(tabs: const [
            'Belum',
            'Jadwal',
            'Selesai'
          ], tabViews: const [
            NotYet(),
            Schedule(),
            Finish(),
          ]))
        ],
      ),
    );
  }
}
