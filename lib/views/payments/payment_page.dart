import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/payments/payment_cmp.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

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
                'Pembayar',
                style: AppTextStyles.heading1SemiBold(),
              )
            ],
          ),
        ),
      ),
      body: const PaymentCmp(
        doctorName: 'dr.Palomina',
        specialization: 'Anak',
        price: '50',
        session: '1',
        isExpertGroup: true,
      ),
    );
  }
}
