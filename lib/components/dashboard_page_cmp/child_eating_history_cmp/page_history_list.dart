import 'package:flutter/material.dart';

import 'history_list_cmp.dart';

class PageHistoryList extends StatelessWidget {
  const PageHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HistoryListCmp(
              mealTime: 'Makan siang',
              hour: 10.3,
              carbohydrate: 20,
              proteins: 20,
              fat: 20,
              totalcalories: 54564,
              itemName:
                  'Bubur Salmon Teriyaki, Jus Naga, Bubur Salmon Teriyaki, Jus Naga',
            ),
            HistoryListCmp(
              mealTime: 'Makan siang',
              hour: 10.3,
              carbohydrate: 20,
              proteins: 20,
              fat: 20,
              totalcalories: 54564,
              itemName:
                  'Bubur Salmon Teriyaki, Jus Naga, Bubur Salmon Teriyaki, Jus Naga',
            ),
            HistoryListCmp(
              mealTime: 'Makan malam',
              hour: 10.3,
              carbohydrate: 20,
              proteins: 20,
              fat: 20,
              totalcalories: 54564,
              itemName:
                  'Bubur Salmon Teriyaki, Jus Naga, Bubur Salmon Teriyaki, Jus Naga',
            ),
            HistoryListCmp(
              mealTime: 'Cemilan Pagi',
              hour: 10.3,
              carbohydrate: 20,
              proteins: 20,
              fat: 20,
              totalcalories: 545,
              itemName:
                  'Bubur Salmon Teriyaki, Jus Naga, Bubur Salmon Teriyaki, Jus Naga',
            ),
          ],
        ),
      ),
    );
  }
}
