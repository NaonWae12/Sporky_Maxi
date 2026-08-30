import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/explore_page/explore_page.dart';
import 'package:sporky_maxi/views/home_page/child_dashboard_page.dart';
import 'package:sporky_maxi/views/meal_plan_page/meal_plan_main_page.dart';

import '../chatroom/chatroom_page.dart';
import '../dashboard_page/dashboard_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ChildDashboardPage(onDashboardTap: () => _onItemTapped(4)),
      const ExplorePage(),
      const MealPlanMainPage(),
      const ChatroomPage(),
      const DashboardPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        type: BottomNavigationBarType.fixed, // Penting biar 5 item bisa muat
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
              "assets/svg/compass-rounded.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1 ? Colors.black : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svg/bento-box-rounded.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2 ? Colors.black : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svg/chat-rounded.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 3 ? Colors.black : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Chatroom',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svg/chart-fill-rounded.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 4 ? Colors.black : Colors.grey,
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
