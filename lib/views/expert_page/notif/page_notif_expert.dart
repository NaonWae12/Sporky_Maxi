import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/card_notification_cmp.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PageNotifExpert extends StatelessWidget {
  const PageNotifExpert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 5),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            Text(
              'Notifikasi',
              style: AppTextStyles.heading2SemiBold(),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hari ini',
                style: AppTextStyles.heading3SemiBold(),
              ),
            ),
          ),
          CardNotificationCmp(
            title: 'Beri Rating Konsultasi',
            desc: 'Bagaimana sesi bersama dr. Arif kemarin? Yuk beri rating!',
            category: "consultations",
            iconColor: AppColors.base1,
          ),
          CardNotificationCmp(
            title: 'Beri Rating Konsultasi',
            desc: 'Bagaimana sesi bersama dr. Arif kemarin? Yuk beri rating!',
            category: "video",
            iconColor: AppColors.base1,
          ),
          CardNotificationCmp(
            title: 'Beri Rating Konsultasi',
            desc: 'Bagaimana sesi bersama dr. Arif kemarin? Yuk beri rating!',
            category: "chat",
            iconColor: AppColors.warn1,
          ),
        ],
      ),
    );
  }
}
