import 'package:flutter/material.dart';
import 'package:sporky_maxi/views/meal_plan_page/all_content/all_content_page.dart';

class SnackContentPage extends StatelessWidget {
  final String searchQuery;

  const SnackContentPage({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    return AllContentPage(searchQuery: searchQuery, category: 'cemilan');
  }
}
