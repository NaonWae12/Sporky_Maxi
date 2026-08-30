import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/form_food_waste/page_form_food_waste.dart';
import 'package:sporky_maxi/views/subscriptions/subs_plan_page.dart';

import '../../views/consultation/main_page_consultation.dart';
import '../../views/consultation/ticket_consultation/main_page_ticket_cst.dart';
import '../../views/vouchers/main_page_vouchers.dart';
import '../../views/meal_form/meal_form_main_page.dart';
import '../globals/card/icon_lable_card.dart';
import '../globals/colors/colors.dart';

class CardConsultation extends StatelessWidget {
  final VoidCallback? onGrowthTap;

  const CardConsultation({super.key, this.onGrowthTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 2),
        child: Row(
          children: [
            IconLabelCard(
              imageAsset: 'assets/svg/ic_ doctor.svg',
              label: 'Konsultasi',
              colorImageAndText: AppColors.secondary1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPageConsultation(),
                  ),
                );
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/ic_pie_chart.svg',
              label: 'Catat kalori Harian',
              colorImage: AppColors.warn4,
              colorText: AppColors.secondary1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealFormMainPage()),
                );
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/ic_ growth.svg',
              label: 'Tumbuh Kembang',
              colorImage: AppColors.success2,
              colorText: AppColors.secondary1,
              onTap: onGrowthTap,
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/food-bank.svg',
              label: 'Food Waste',
              colorImage: AppColors.success2,
              colorText: AppColors.secondary1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PageFormFoodWaste(),
                  ),
                );
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/sun.svg',
              label: 'Langganan',
              colorText: AppColors.secondary1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubsPlanPage()),
                );
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/ic_coupon - ticket.svg',
              label: 'Voucher',
              colorImage: AppColors.warn4,
              colorText: AppColors.secondary1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPageVouchers(),
                  ),
                );
              },
            ),
            IconLabelCard(
              imageAsset: 'assets/svg/ic_coupon - ticket.svg',
              label: 'Ticket',
              colorText: AppColors.secondary1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPageTicketCst()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
