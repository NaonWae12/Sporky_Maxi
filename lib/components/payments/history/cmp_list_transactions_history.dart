import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../globals/currency/currency_formatter.dart';

class CmpListTransactionsHistory extends StatelessWidget {
  final String iconAsset;
  final Color? iconColor;
  final String title;
  final double price;
  final String desc;
  final String timeStamp;
  final String transactionType;

  const CmpListTransactionsHistory({
    super.key,
    required this.iconAsset,
    this.iconColor,
    required this.title,
    required this.price,
    required this.desc,
    required this.timeStamp,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            const SizedBox(
              height: 35,
              width: 35,
            ),
            SvgPicture.asset(
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
                height: 32,
                width: 32,
                iconAsset),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                transactionType == 'in'
                    ? 'assets/svg/ic_arrow_right.svg'
                    : 'assets/svg/ic_arrow_bottom.svg',
                height: 10,
                width: 10,
              ),
            )
          ],
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTextStyles.list1Bold()),
                  Text(formatRupiah(price), style: AppTextStyles.list1Bold()),
                ],
              ),
              Text(desc, style: AppTextStyles.list1Regular(AppColors.base3)),
              Text(timeStamp,
                  style: AppTextStyles.list1Regular(AppColors.base3)),
            ],
          ),
        )
      ],
    );
  }
}
