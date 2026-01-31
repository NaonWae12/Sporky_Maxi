import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../components/chatroom_cmp/cmp_list_chat.dart';

class AllChat extends StatelessWidget {
  const AllChat({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const CmpListChat(
              name: 'dr. Palomina',
              message:
                  'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
              time: '10.08',
              unreadCount: 5,
              isActive: true,
              photoUrl: 'assets/temp_img/parent.png',
              isAsset: true,
            ),
            const CmpListChat(
              name: 'dr. Palomina',
              message:
                  'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
              time: '10.08',
              unreadCount: 5,
              isActive: true,
              photoUrl: 'assets/temp_img/parent.png',
              isAsset: true,
            ),
            const CmpListChat(
              name: 'dr. Palomina',
              message:
                  'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
              time: '10.08',
              unreadCount: 5,
              isActive: true,
              photoUrl: 'assets/temp_img/parent.png',
              isAsset: true,
            ),
            const CmpListChat(
              name: 'dr. Palomina',
              message:
                  'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
              time: '10.08',
              unreadCount: 5,
              isActive: true,
              photoUrl: 'assets/temp_img/parent.png',
              isAsset: true,
            ),
            const SizedBox(height: 10),
            GlobalsButton(
              width: MediaQuery.of(context).size.width / 1.05,
              onPressed: () {},
              color: AppColors.secondary1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svg/ic_coupon - ticket.svg'),
                  const SizedBox(width: 8),
                  Text(
                    'Beli Tiket Konsultasi',
                    style: AppTextStyles.headList1Bold(AppColors.base5),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
