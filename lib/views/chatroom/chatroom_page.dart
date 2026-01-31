import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/form/search_input.dart';

import 'all_chat/all_chat.dart';
import 'doctor_chat/doctor_chat.dart';
import 'nutritionists_chat/nutritionists_chat.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            const SizedBox(height: 15),
            SearchInput(
                controller: searchController,
                hintText: 'cari chat siapa?',
                showHeartIcon: false),
            Expanded(
                child: FullWidthTabBar(tabs: const [
              'Semua',
              'Dokter',
              'Ahli Gizi'
            ], tabViews: const [
              AllChat(),
              DoctorChat(),
              NutritionistsChat(),
            ]))
          ],
        ),
      ),
    );
  }
}
