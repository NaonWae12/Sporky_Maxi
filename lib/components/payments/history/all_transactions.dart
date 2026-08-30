import 'package:flutter/material.dart';

import 'transaction_history_list.dart';

class AllTransactions extends StatelessWidget {
  const AllTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionHistoryList(filter: TransactionHistoryFilter.all);
  }
}
