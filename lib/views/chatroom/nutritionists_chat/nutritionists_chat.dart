import 'package:flutter/material.dart';
import '../../../components/chatroom_cmp/cmp_list_chat.dart';
import '../../../components/globals/button/cmp_floating_button.dart';

class NutritionistsChat extends StatelessWidget {
  const NutritionistsChat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: CmpFloatingActionButton(
        imagePath: 'assets/temp_img/parent.png',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(height: 18),
              CmpListChat(
                name: 'dr. Palomina',
                message:
                    'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
                time: '10.08',
                unreadCount: 5,
                isActive: true,
                photoUrl: 'assets/temp_img/parent.png',
                isAsset: true,
              ),
              CmpListChat(
                name: 'dr. Palomina',
                message:
                    'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
                time: '10.08',
                unreadCount: 5,
                isActive: true,
                photoUrl: 'assets/temp_img/parent.png',
                isAsset: true,
              ),
              CmpListChat(
                name: 'dr. Palomina',
                message:
                    'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
                time: '10.08',
                unreadCount: 5,
                isActive: true,
                photoUrl: 'assets/temp_img/parent.png',
                isAsset: true,
              ),
              CmpListChat(
                name: 'dr. Palomina',
                message:
                    'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
                time: '10.08',
                unreadCount: 5,
                isActive: true,
                photoUrl: 'assets/temp_img/parent.png',
                isAsset: true,
              ),
              CmpListChat(
                name: 'dr. Palomina',
                message:
                    'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
                time: '10.08',
                unreadCount: 5,
                isActive: true,
                photoUrl: 'assets/temp_img/parent.png',
                isAsset: true,
              ),
              CmpListChat(
                name: 'dr. Palomina',
                message:
                    'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
                time: '10.08',
                unreadCount: 5,
                isActive: true,
                photoUrl: 'assets/temp_img/parent.png',
                isAsset: true,
              ),
              CmpListChat(
                name: 'dr. Palomina',
                message:
                    'Kalau BB dan tinggi Kiara masih sesuai kurva tumbuh, belum perlu suplemen ya, Bun. Tapi nanti bisa saya cek grafik tumbuhnya kalau Bunda punya datanya 😊',
                time: '10.08',
                unreadCount: 5,
                isActive: true,
                photoUrl: 'assets/temp_img/parent.png',
                isAsset: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
