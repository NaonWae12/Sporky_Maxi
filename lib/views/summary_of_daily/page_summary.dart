import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';

import '../../components/globals/text/text_style.dart';
import '../../components/summary_cmp/summary_cmp.dart';

class PageSummary extends StatelessWidget {
  const PageSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                'Ringkasan Asupan  Harian',
                style: AppTextStyles.heading2SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: const Column(
        children: [
          CmpTagAttention(
              imageAsset: 'assets/svg/ic_warn.svg',
              text:
                  'Catatan hari ini membantu kamu memahami pola makan dan pertumbuhan si kecil. '),
          SummaryCmp(),
        ],
      ),
    );
  }
}
