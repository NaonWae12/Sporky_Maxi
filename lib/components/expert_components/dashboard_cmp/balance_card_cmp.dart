import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class BalanceCardCmp extends StatefulWidget {
  final int? balance;
  final int? balanceCollected;
  final String period;
  final int totalConsultations;
  final VoidCallback? onTapHistory;
  const BalanceCardCmp({
    super.key,
    this.balance = 0,
    this.balanceCollected = 0,
    this.period = '-',
    this.totalConsultations = 0,
    this.onTapHistory,
  });

  @override
  State<BalanceCardCmp> createState() => _BalanceCardCmpState();
}

class _BalanceCardCmpState extends State<BalanceCardCmp> {
  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      hasShadow: false,
      backgroundColor: AppColors.base4,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Saldo Konsultasi',
                        style: AppTextStyles.heading3SemiBold(),
                      ),
                      GlobalsCard(
                          onTap: () {},
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          backgroundColor: AppColors.base5,
                          hasShadow: false,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset(
                              'assets/svg/ic_eye.svg',
                              colorFilter: ColorFilter.mode(
                                  AppColors.base1, BlendMode.srcIn),
                            ),
                          ))
                    ],
                  ),
                  Text(
                    'Rp.${widget.balance}',
                    style: AppTextStyles.heading1SemiBold(),
                  )
                ],
              ),
              GlobalsCard(
                  backgroundColor: AppColors.base5,
                  hasShadow: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/svg/ic_withdraw.svg'),
                        Text(
                          'Tarik Saldo',
                          style: AppTextStyles.lable4SemiRegular(),
                        )
                      ],
                    ),
                  ))
            ],
          ),
          GestureDetector(
            onTap: widget.onTapHistory,
            child: GlobalsCardOutlined(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Rp.${widget.balanceCollected} ',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Text('${widget.totalConsultations} sesi'),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
