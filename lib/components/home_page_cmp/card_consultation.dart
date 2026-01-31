import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/subscriptions/subs_plan_page.dart';

import '../../views/consultation/main_page_consultation.dart';
import '../../views/meal_form/meal_form_main_page.dart';
import '../globals/card/icon_lable_card.dart';

class CardConsultation extends StatelessWidget {
  const CardConsultation({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 2,
        ),
        child: Row(
          children: [
            IconLabelCard(
              imageAsset: 'assets/svg/user-doctor.svg',
              label: 'Konsultasi',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPageConsultation(),
                    ));
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/ic_pie_chart.svg',
              label: 'Catat kalori Harian',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealFormMainPage(),
                    ));
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/ic_ growth.svg',
              label: 'Tumbuh Kembang',
              onTap: () {},
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/sun.svg',
              label: 'Langganan',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubsPlanPage(),
                    ));
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/ic_coupon - ticket.svg',
              label: 'Voucher',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
