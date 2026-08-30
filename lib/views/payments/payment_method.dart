import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/payments/cmp_payment_method.dart';

import '../../components/globals/text/text_style.dart';

class PaymentMethod extends StatelessWidget {
  final PaymentMethodOption? initialSelection;

  const PaymentMethod({super.key, this.initialSelection});

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
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                'Metode Pembayaran',
                style: AppTextStyles.heading1SemiBold(),
              ),
            ],
          ),
        ),
      ),
      body: CmpPaymentMethod(initialSelection: initialSelection),
    );
  }
}
