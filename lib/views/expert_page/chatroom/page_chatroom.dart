import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/form/search_input.dart';
import '../../../components/globals/button/cmp_floating_button.dart';
import 'all_chat_expert.dart';

class PageChatroom extends StatefulWidget {
  const PageChatroom({super.key});

  @override
  State<PageChatroom> createState() => _PageChatroomState();
}

class _PageChatroomState extends State<PageChatroom> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CmpFloatingActionButton(
        imagePath: 'assets/temp_img/parent.png',
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            const SizedBox(height: 15),
            SearchInput(
                controller: searchController,
                hintText: 'cari chat siapa?',
                showHeartIcon: false),
            const SizedBox(height: 20),
            Expanded(
                child: FullWidthTabBar(tabs: const [
              'Semua',
              'Aktif',
              'Selesai'
            ], tabViews: const [
              AllChatExpert(),
              Center(child: Text('Aktif')),
              Center(child: Text('Selesai')),
            ]))
          ],
        ),
      ),
    );
  }
}
