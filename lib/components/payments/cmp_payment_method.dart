import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals/button/globals_button.dart';
import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class CmpPaymentMethod extends StatefulWidget {
  const CmpPaymentMethod({super.key});

  @override
  State<CmpPaymentMethod> createState() => _CmpPaymentMethodState();
}

class _CmpPaymentMethodState extends State<CmpPaymentMethod> {
  bool isQris = false;
  bool isGopay = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlobalsCard(
          padding: const EdgeInsets.all(12),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          child: Column(
            children: [
              Row(children: [
                SvgPicture.asset(
                    height: 18, width: 18, 'assets/svg/ic_ bill.svg'),
                const SizedBox(width: 5),
                Text(
                  "Rincian Pembayaran",
                  style: AppTextStyles.heading3SemiBold(),
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Harga Paket Berlangganan",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Biaya Layanan 1%",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Pajak 2%",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      const SizedBox(height: 3),
                      RichText(
                        text: TextSpan(
                          text: 'Koin Ditukarkan: ',
                          style: AppTextStyles.list1Regular(AppColors.base2),
                          children: <TextSpan>[
                            TextSpan(
                                text: '3000',
                                style: AppTextStyles.list1Medium(
                                    AppColors.primary1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Total Pembayaran",
                        style: AppTextStyles.headList1Medium(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Rp2.000.000",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      Text(
                        "Rp300.000",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      Text(
                        "-Rp3.000",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      Text(
                        "Rp2.297.000",
                        style: AppTextStyles.headList1Medium(),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        GlobalsCard(
            padding: const EdgeInsets.all(12),
            hasShadow: false,
            height: 42,
            backgroundColor: AppColors.base4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        height: 16, width: 16, 'assets/svg/ic_ qr.svg'),
                    const SizedBox(width: 5),
                    Text(
                      'Qris',
                      style: AppTextStyles.heading3SemiBold(),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => isQris = !isQris),
                  child: Icon(
                    isQris
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: AppColors.primary1,
                    size: 20,
                  ),
                )
              ],
            )),
        GlobalsCard(
            padding: const EdgeInsets.all(12),
            hasShadow: false,
            height: 42,
            backgroundColor: AppColors.base4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        height: 16, width: 16, 'assets/svg/ic_credit_card.svg'),
                    const SizedBox(width: 5),
                    Text(
                      'Gopay',
                      style: AppTextStyles.heading3SemiBold(),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => isGopay = !isGopay),
                  child: Icon(
                    isGopay
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: AppColors.primary1,
                    size: 20,
                  ),
                )
              ],
            )),
        GlobalsCard(
            padding: const EdgeInsets.all(12),
            hasShadow: false,
            height: 42,
            backgroundColor: AppColors.base4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        height: 16, width: 16, 'assets/svg/ic_credit_card.svg'),
                    const SizedBox(width: 5),
                    Text(
                      'Virtual Account (VA)',
                      style: AppTextStyles.heading3SemiBold(),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => isGopay = !isGopay),
                  child: Icon(
                    isGopay
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: AppColors.primary1,
                    size: 20,
                  ),
                )
              ],
            )),
        GlobalsCard(
            padding: const EdgeInsets.all(12),
            hasShadow: false,
            height: 42,
            backgroundColor: AppColors.base4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        height: 16, width: 16, 'assets/svg/ic_credit_card.svg'),
                    const SizedBox(width: 5),
                    Text(
                      'Debit/Credit Card',
                      style: AppTextStyles.heading3SemiBold(),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => isGopay = !isGopay),
                  child: Icon(
                    isGopay
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: AppColors.primary1,
                    size: 20,
                  ),
                )
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlobalsButton(
            color: isGopay
                ? isQris
                    ? AppColors.secondary1
                    : AppColors.secondary3
                : AppColors.secondary3,
            text: "Pilih",
            customTextStyle: AppTextStyles.headList1Bold(),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
