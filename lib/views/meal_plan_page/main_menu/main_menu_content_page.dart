import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/meal_plan_page/all_content/all_content_page.dart';

class MainMenuContentPage extends StatelessWidget {
  final String searchQuery;

  const MainMenuContentPage({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    return AllContentPage(searchQuery: searchQuery, category: 'makan');
  }
}
