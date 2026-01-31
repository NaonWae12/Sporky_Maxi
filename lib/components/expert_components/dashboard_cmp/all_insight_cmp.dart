import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import 'chat_card_cmp.dart';
import 'total_card_cmp.dart';
import 'zoom_card_cmp.dart';

class AllInsightCmp extends StatelessWidget {
  const AllInsightCmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChatCardCmp(
              count: '48',
            ),
            ZoomCardCmp(),
            TotalCardCmp()
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {},
            child: GlobalsCardOutlined(
              backgroundColor: Colors.transparent,
              height: 30,
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Riwayat Konsultasi',
                    style: AppTextStyles.list1Bold(),
                  ),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
