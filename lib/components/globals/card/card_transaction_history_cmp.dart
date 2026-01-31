import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

enum TransactionsType { chat, video, withdraw }

enum TransactionsCategory { incoming, outcoming }

class CardTransactionHistoryCmp extends StatelessWidget {
  final String nameParrent;
  final String nameChild;
  final TransactionsType type;
  final TransactionsCategory category;
  final String balance;
  final bool isSuccess;
  final String? bankName;
  final String? accountNumber;

  const CardTransactionHistoryCmp({
    super.key,
    required this.nameChild,
    required this.nameParrent,
    this.type = TransactionsType.chat,
    this.category = TransactionsCategory.incoming,
    this.balance = '0',
    this.isSuccess = true,
    this.bankName,
    this.accountNumber,
  });

  String get _iconAsset {
    switch (type) {
      case TransactionsType.chat:
        return 'assets/svg/shape_chat.svg';
      case TransactionsType.video:
        return 'assets/svg/shape_video.svg';
      case TransactionsType.withdraw:
        return 'assets/svg/ic_withdraw.svg';
    }
  }

  String get _categoryTransactions {
    switch (category) {
      case TransactionsCategory.incoming:
        return 'assets/svg/ic_arrow_bottom.svg';
      case TransactionsCategory.outcoming:
        return 'assets/svg/ic_arrow_right.svg';
    }
  }

  String get _statusIcon =>
      isSuccess ? 'assets/svg/ic_success.svg' : 'assets/svg/ic_close.svg';

  @override
  Widget build(BuildContext context) {
    final bool isWithdraw = type == TransactionsType.withdraw;

    return GlobalsCard(
      height: 76,
      hasShadow: false,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            _iconAsset,
                            width: 40,
                            colorFilter: ColorFilter.mode(
                                AppColors.secondary1, BlendMode.srcIn),
                          ),
                          SvgPicture.asset(_categoryTransactions),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isWithdraw ? 'Tarik Saldo' : 'Pembayaran Konsultasi',
                          style: AppTextStyles.list1Bold(),
                        ),
                        Row(
                          children: [
                            if (!isWithdraw) ...[
                              Text(
                                nameParrent,
                                style:
                                    AppTextStyles.list1Regular(AppColors.base3),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/svg/ic_bear_child.svg',
                                height: 12,
                                width: 12,
                                colorFilter: ColorFilter.mode(
                                    AppColors.base3, BlendMode.srcIn),
                              ),
                              Text(
                                nameChild,
                                style:
                                    AppTextStyles.list1Regular(AppColors.base3),
                              ),
                            ] else ...[
                              Text(
                                'via ${bankName ?? '-'} ${accountNumber ?? ''}',
                                style:
                                    AppTextStyles.list1Regular(AppColors.base3),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(_statusIcon),
                  const SizedBox(width: 6),
                  Text(
                    'Rp$balance',
                    style: AppTextStyles.list1Bold(),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ],
          ),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width / 1.1,
            color: AppColors.base3,
          )
        ],
      ),
    );
  }
}
