import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class CmpTabTicketExpert extends StatelessWidget {
  final String chatPrice;
  final String callPrice;
  final String session;
  final String duration;
  final VoidCallback buyTicketChat;
  final VoidCallback buyTicketCall;

  const CmpTabTicketExpert({
    super.key,
    this.chatPrice = '-',
    this.callPrice = '-',
    this.session = '-',
    this.duration = '-',
    required this.buyTicketCall,
    required this.buyTicketChat,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 5),
          const CmpTagAttention(
              text:
                  'Tiket konsultasi bisa digunakan saat ini juga jika expert sedang online, atau Bunda bisa atur jadwal lain kapan pun yang pas.',
              imageAsset: 'assets/svg/ic_ calendar - schedule.svg',
              imageColor: AppColors.info1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalsCard(
                      margin: const EdgeInsets.only(
                          left: 16, top: 8, bottom: 8, right: 4),
                      height: 134,
                      width: 165,
                      padding: const EdgeInsets.all(8),
                      backgroundColor: AppColors.base5,
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          SvgPicture.asset(
                              height: 36,
                              width: 37,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.secondary1, BlendMode.srcIn),
                              'assets/svg/chat-rounded.svg'),
                          Text('Rp $chatPrice',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.headList1Bold()),
                          GlobalsCard(
                              hasShadow: false,
                              backgroundColor: AppColors.base3,
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        height: 9,
                                        width: 9,
                                        'assets/svg/ic_clock.svg'),
                                    Text('$session Sesi',
                                        style: AppTextStyles.list3Regular()),
                                    const SizedBox(width: 5),
                                    Text(duration,
                                        style: AppTextStyles.list3Bold()),
                                    Text(' Menit',
                                        style: AppTextStyles.list3Regular()),
                                  ])),
                          GlobalsButton(
                            color: AppColors.secondary1,
                            height: 22,
                            width: MediaQuery.of(context).size.width / 3,
                            onPressed: buyTicketChat,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    height: 12,
                                    width: 12,
                                    'assets/svg/ic_coupon - ticket.svg'),
                                const SizedBox(width: 5),
                                Text(
                                  'Beli Tiket',
                                  style:
                                      AppTextStyles.list1Bold(AppColors.base5),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            height: 12,
                            width: 12,
                            colorFilter: const ColorFilter.mode(
                                AppColors.base2, BlendMode.srcIn),
                            'assets/svg/ic_warn.svg'),
                        Text(
                          'Respon cepat & praktis',
                          style: AppTextStyles.list3Regular(AppColors.base2),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8)
                ],
              ),
              // pembatas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalsCard(
                      height: 134,
                      width: 165,
                      margin: const EdgeInsets.only(
                          right: 16, top: 8, bottom: 8, left: 4),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: AppColors.base5,
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          SvgPicture.asset(
                              height: 36,
                              width: 37,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.secondary1, BlendMode.srcIn),
                              'assets/svg/ic_ video call.svg'),
                          Text('Rp $callPrice',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.headList1Bold()),
                          GlobalsCard(
                              hasShadow: false,
                              backgroundColor: AppColors.base3,
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        height: 9,
                                        width: 9,
                                        'assets/svg/ic_clock.svg'),
                                    Text('$session Sesi',
                                        style: AppTextStyles.list3Regular()),
                                    const SizedBox(width: 5),
                                    Text(duration,
                                        style: AppTextStyles.list3Bold()),
                                    Text(' Menit',
                                        style: AppTextStyles.list3Regular()),
                                  ])),
                          GlobalsButton(
                            color: AppColors.secondary1,
                            height: 22,
                            width: MediaQuery.of(context).size.width / 3,
                            onPressed: buyTicketCall,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    height: 12,
                                    width: 12,
                                    'assets/svg/ic_coupon - ticket.svg'),
                                const SizedBox(width: 5),
                                Text(
                                  'Beli Tiket',
                                  style:
                                      AppTextStyles.list1Bold(AppColors.base5),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            height: 12,
                            width: 12,
                            colorFilter: const ColorFilter.mode(
                                AppColors.base2, BlendMode.srcIn),
                            'assets/svg/ic_warn.svg'),
                        Text(
                          'Sesi tatap muka lebih personal',
                          style: AppTextStyles.list3Regular(AppColors.base2),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
