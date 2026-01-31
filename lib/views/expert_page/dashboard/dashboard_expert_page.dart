import 'package:flutter/material.dart';

import '../../../components/expert_components/dashboard_cmp/balance_card_cmp.dart';
import '../../../components/expert_components/dashboard_cmp/insight_consultation_cmp.dart';
import '../../../components/globals/bar/top_bar/top_bar_expert_cmp.dart';
import 'transaction/page_transaction_history.dart';

class DashboardExpertPage extends StatelessWidget {
  const DashboardExpertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: TopBarExpertCmp(
            name: 'dr. Kevin',
            title: 'Ahli Gizi, Spesialis Rehabilitas Nutrisi'),
      ),
      body: Column(
        children: [
          BalanceCardCmp(
            onTapHistory: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageTransactionHistory(),
                  ));
            },
          ),
          const SizedBox(height: 15),
          InsightConsultationCmp()
        ],
      ),
    );
  }
}
