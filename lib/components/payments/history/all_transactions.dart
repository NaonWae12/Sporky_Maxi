import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../globals/text/text_style.dart';
import 'cmp_list_transactions_history.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  Map<String, List<Map<String, dynamic>>> groupTransactionsByDate(
      List<Map<String, dynamic>> transactions) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var tx in transactions) {
      final date = DateFormat('dd/MM/yyyy').parse(tx['timeStamp']);
      final txDate = DateTime(date.year, date.month, date.day);

      String key;
      if (txDate == today) {
        key = 'Hari Ini';
      } else if (txDate == yesterday) {
        key = 'Kemarin';
      } else {
        key = DateFormat('d MMMM yyyy', 'id_ID').format(txDate);
      }

      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return grouped;
  }

  final List<Map<String, dynamic>> transactions = [
    {
      'iconAsset': 'assets/svg/Crown-1.svg',
      'title': 'Pembayaran Berlangganan',
      'price': 295000,
      'desc': 'via Gopay 081234567890',
      'timeStamp': '19/07/2025',
      'transactionType': 'in'
    },
    {
      'iconAsset': 'assets/svg/Crown-1.svg',
      'title': 'Pembayaran Konsultasi',
      'price': 80000,
      'desc': 'via Gopay 081234567890',
      'timeStamp': '20/06/2025',
      'transactionType': 'in'
    },
    // tambahkan lagi jika perlu...
  ];
  @override
  Widget build(BuildContext context) {
    final grouped = groupTransactionsByDate(transactions);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.key, style: AppTextStyles.heading2SemiBold()),
            const SizedBox(height: 8),
            ...entry.value.map((tx) => Column(
                  children: [
                    CmpListTransactionsHistory(
                      iconAsset: tx['iconAsset'],
                      title: tx['title'],
                      price: tx['price'],
                      desc: tx['desc'],
                      timeStamp: tx['timeStamp'],
                      transactionType: tx['transactionType'],
                    ),
                    const Divider(),
                  ],
                )),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
}
