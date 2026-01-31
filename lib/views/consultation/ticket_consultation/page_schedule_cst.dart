import 'package:flutter/material.dart';

import '../../../components/consultation_cmp/ticket_consultation_cmp/cmp_schedule_cst.dart';
import '../../../components/globals/card/cmp_tag_attention.dart';
import '../../../components/globals/colors/colors.dart';
import '../../../components/globals/text/text_style.dart';

class PageScheduleCst extends StatelessWidget {
  const PageScheduleCst({super.key});

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
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                )),
            Text(
              'Jadwalkan Chat Konsultasi',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: const Column(
        children: [
          CmpTagAttention(
              text:
                  'Bunda bisa pilih tanggal & jam, anak yang ingin dikonsultasikan, serta topik yang ingin dibahas. Dokter akan membaca informasi ini sebelum sesi dimulai.',
              imageAsset: 'assets/svg/ic_ calendar - schedule.svg',
              imageColor: AppColors.info1),
          CmpScheduleCst()
        ],
      ),
    );
  }
}
