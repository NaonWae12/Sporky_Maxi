import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/bar/full_width_tab_bar.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import 'all_transactions_in_expert.dart';

class PageTransactionHistory extends StatelessWidget {
  const PageTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            Text('Riwayat Transaksi', style: AppTextStyles.heading2SemiBold())
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FullWidthTabBar(tabs: const [
          'Semua',
          'Saldo Masuk',
          'Saldo Keluar'
        ], tabViews: const [
          AllTransactionsInExpert(),
          Center(child: Text('Saldo Masuk')),
          Center(child: Text('Saldo Keluar')),
        ]),
      ),
    );
  }
}
