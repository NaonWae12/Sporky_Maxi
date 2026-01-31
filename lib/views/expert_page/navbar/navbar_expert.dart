import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/expert_page/home_page/home_page.dart';

import '../chatroom/page_chatroom.dart';
import '../dashboard/dashboard_expert_page.dart';

class NavbarExpert extends StatefulWidget {
  const NavbarExpert({super.key});

  @override
  State<NavbarExpert> createState() => _NavbarExpertState();
}

class _NavbarExpertState extends State<NavbarExpert> {
  int _selectedIndex = 0;

  // Contoh halaman buat setiap tab
  static const List<Widget> _pages = [
    HomePage(),
    PageChatroom(),
    DashboardExpertPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svg/home-rounded.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0 ? Colors.black : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svg/chat-rounded.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1 ? Colors.black : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Chatroom',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svg/chart-fill-rounded.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2 ? Colors.black : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Dashboard',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.base1,
        unselectedItemColor: AppColors.base2,
        onTap: _onItemTapped,
        selectedLabelStyle: AppTextStyles.lable3Regular(),
        unselectedLabelStyle: AppTextStyles.lable3Regular(),
      ),
    );
  }
}
