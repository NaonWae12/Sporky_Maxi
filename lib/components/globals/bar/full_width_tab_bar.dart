import 'package:flutter/material.dart';

class FullWidthTabBar extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> tabViews;
  final ValueChanged<int>? onTabChanged; // <-- tambahkan ini
  final Color labelColor;
  final Color unselectedLabelColor;
  final Color indicatorColor;

  const FullWidthTabBar({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.onTabChanged,
    this.labelColor = Colors.indigo,
    this.unselectedLabelColor = Colors.grey,
    this.indicatorColor = Colors.indigo,
  }) : assert(tabs.length == tabViews.length);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final TabController controller = DefaultTabController.of(context);
          controller.addListener(() {
            if (controller.indexIsChanging) {
              onTabChanged?.call(controller.index);
            }
          });
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: TabBar(
                  labelColor: labelColor,
                  unselectedLabelColor: unselectedLabelColor,
                  indicatorColor: indicatorColor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: tabs.map((tab) => ExpandedTab(text: tab)).toList(),
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: tabViews,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ExpandedTab extends StatelessWidget {
  final String text;

  const ExpandedTab({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: double.infinity, // biar tiap tab penuh
      child: Tab(
        child: Center(child: Text(text)),
      ),
    );
  }
}
