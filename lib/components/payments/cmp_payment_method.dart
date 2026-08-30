import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals/button/globals_button.dart';
import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

enum PaymentMethodOption { qris, gopay, virtualAccount, card }

class CmpPaymentMethod extends StatefulWidget {
  final PaymentMethodOption? initialSelection;
  final ValueChanged<PaymentMethodOption>? onSelected;

  const CmpPaymentMethod({super.key, this.initialSelection, this.onSelected});

  @override
  State<CmpPaymentMethod> createState() => _CmpPaymentMethodState();
}

class _CmpPaymentMethodState extends State<CmpPaymentMethod> {
  late PaymentMethodOption? _selected = widget.initialSelection;

  void _select(PaymentMethodOption option) {
    setState(() {
      _selected = option;
    });
    widget.onSelected?.call(option);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...PaymentMethodOption.values.map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PaymentMethodCard(
              option: option,
              isSelected: _selected == option,
              onTap: () => _select(option),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlobalsButton(
            color: _selected == null
                ? AppColors.secondary3
                : AppColors.secondary1,
            text: 'Pilih',
            customTextStyle: AppTextStyles.headList1Bold(),
            onPressed: _selected == null
                ? null
                : () => Navigator.of(context).pop(_selected),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethodOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      padding: const EdgeInsets.all(12),
      hasShadow: false,
      backgroundColor: AppColors.base4,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                height: 16,
                width: 16,
                option == PaymentMethodOption.qris
                    ? 'assets/svg/ic_ qr.svg'
                    : 'assets/svg/ic_credit_card.svg',
              ),
              const SizedBox(width: 5),
              Text(_label, style: AppTextStyles.heading3SemiBold()),
            ],
          ),
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: AppColors.primary1,
            size: 20,
          ),
        ],
      ),
    );
  }

  String get _label {
    return switch (option) {
      PaymentMethodOption.qris => 'QRIS',
      PaymentMethodOption.gopay => 'Gopay',
      PaymentMethodOption.virtualAccount => 'Virtual Account (VA)',
      PaymentMethodOption.card => 'Debit/Credit Card',
    };
  }
}
