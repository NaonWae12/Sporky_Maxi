import 'package:flutter/material.dart';

import '../../../../components/globals/card/card_transaction_history_cmp.dart';

class AllTransactionsInExpert extends StatelessWidget {
  const AllTransactionsInExpert({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardTransactionHistoryCmp(
          nameParrent: 'Dr. Andi',
          nameChild: 'Budi',
          type: TransactionsType.chat,
          category: TransactionsCategory.incoming,
          balance: '50.000',
          isSuccess: true,
        ),
        CardTransactionHistoryCmp(
          nameParrent: 'Alicia',
          nameChild: 'Azzahra',
          type: TransactionsType.withdraw,
          category: TransactionsCategory.outcoming,
          balance: '250.000',
          isSuccess: false,
          bankName: 'BCA',
          accountNumber: '612345987',
        ),
      ],
    );
  }
}
