import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/expert_page/chatroom/detail_profile.dart';

import '../../../components/chatroom_cmp/cmp_list_chat.dart';

class AllChatExpert extends StatelessWidget {
  final String childUuid;
  const AllChatExpert({super.key, required this.childUuid});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            CmpListChat(
              name: 'dr. Palomina',
              message:
                  'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
              time: '10.08',
              unreadCount: 5,
              isActive: false,
              photoUrl: 'assets/temp_img/parent.png',
              isAsset: true,
              maxLines: 1,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProfile(
                        childUuid: childUuid,
                      ),
                    ));
              },
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
              maxLines: 1,
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
              maxLines: 1,
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
              maxLines: 1,
            ),
            TextButton(onPressed: () {}, child: Text('data')),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
