// belum digunakan
import 'package:flutter/material.dart';

class GlobalsTabBar extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> tabViews;
  final TabController? controller;
  final Color labelColor;
  final Color unselectedLabelColor;
  final Color indicatorColor;

  const GlobalsTabBar({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.controller,
    this.labelColor = Colors.black,
    this.unselectedLabelColor = Colors.grey,
    this.indicatorColor = Colors.blue,
  }) : assert(
          tabs.length == tabViews.length,
        );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            controller: controller,
            isScrollable: true,
            labelColor: labelColor,
            unselectedLabelColor: unselectedLabelColor,
            indicatorColor: indicatorColor,
            indicatorWeight: 2,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: tabViews,
            ),
          ),
        ],
      ),
    );
  }
}
