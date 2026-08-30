import 'package:flutter/material.dart';

import 'transaction_history_list.dart';

class Koin extends StatelessWidget {
  const Koin({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionHistoryList(filter: TransactionHistoryFilter.point);
  }
}
