import 'package:flutter/material.dart';

import '../../components/globals/bar/full_width_tab_bar.dart';
import '../../components/globals/text/text_style.dart';
import '../../components/payments/history/all_transactions.dart';
import '../../components/payments/history/koin.dart';
import '../../components/payments/history/product_sporky.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                'Riwayat Transaksi',
                style: AppTextStyles.heading2SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: FullWidthTabBar(
        tabs: const ['Semua', 'Produk Sporky', 'Koin'],
        tabViews: const [
          AllTransactions(),
          ProductSporky(),
          Koin(),
        ],
      ),
    );
  }
}
