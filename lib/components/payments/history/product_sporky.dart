import 'package:flutter/material.dart';

import 'transaction_history_list.dart';

class ProductSporky extends StatelessWidget {
  const ProductSporky({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionHistoryList(
      filter: TransactionHistoryFilter.product,
    );
  }
}
