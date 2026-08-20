import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/meal_plan_page/all_content/all_content_page.dart';
import 'package:sporky_maxi/views/meal_plan_page/meal_plan_fav.dart';
import '../../components/globals/bar/full_width_tab_bar.dart';
import '../../components/globals/form/search_input.dart';
import 'main_menu/main_menu_content_page.dart';
import 'snack/snack_content_page.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SearchInput(
                  onLeadingPressed: () {
                    Navigator.pop(context);
                  },
                  showLeadingIcon: true,
                  hintText: 'brokoli pasta',
                  controller: searchController,
                  onHeartPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MealPlanFav(),
                        ));
                  }),
            ),
            Expanded(
              child: FullWidthTabBar(
                tabs: const ['Semua', 'Menu Utama', 'Cemilan'],
                tabViews: [
                  AllContentPage(searchQuery: searchController.text),
                  MainMenuContentPage(searchQuery: searchController.text),
                  SnackContentPage(searchQuery: searchController.text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
