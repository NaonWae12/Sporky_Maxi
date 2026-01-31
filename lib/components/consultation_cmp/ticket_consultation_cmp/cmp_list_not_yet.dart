import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../views/consultation/ticket_consultation/page_schedule_cst.dart';
import '../../globals/button/globals_button.dart';
import '../../globals/card/globals_card.dart';
import '../../globals/card/globals_card_outlined.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/text_style.dart';
import 'tes/jadwal_konsultasi_page.dart';

class CmpListNotYet extends StatelessWidget {
  final VoidCallback? onTap;
  final String? imageAsset;
  final bool isAvailable;
  final bool showChat;
  final bool showVideoCall;
  final String role;

  final String? ticketType;
  final String doctorName;
  final String ticketCount;
  final String expire;
  final String workingHours;
  final String workingDays;

  const CmpListNotYet({
    super.key,
    this.onTap,
    this.imageAsset,
    required this.isAvailable,
    this.showChat = true,
    this.showVideoCall = true,
    this.role = 'dokter',
    this.ticketType,
    required this.doctorName,
    this.ticketCount = '-',
    this.expire = '-',
    this.workingHours = '-',
    this.workingDays = '-',
  });

  Color _getRoleColor() {
    switch (role.toLowerCase()) {
      case 'dokter':
        return AppColors.secondary2;
      case 'ahli gizi':
        return AppColors.primary1;
      default:
        return AppColors.base2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> infoItems = [
      {
        'icon': 'assets/svg/ic_ calendar - schedule.svg',
        'text': workingDays,
      },
      {
        'icon': 'assets/svg/ic_clock.svg',
        'text': workingHours,
      },
      {
        'icon': 'assets/svg/ic_ calendar - schedule.svg',
        'text': 'Berlaku Hingga: $expire',
      },
      {
        'icon': 'assets/svg/ic_coupon - ticket.svg',
        'text': 'Jumlah Tiket $ticketCount',
      },
    ];
    final bool effectiveShowChat = isAvailable ? showChat : false;
    final bool effectiveShowVideoCall = isAvailable ? showVideoCall : false;

    return GlobalsCard(
      onTap: onTap,
      hasShadow: false,
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageAsset != null
                        ? Image.asset(
                            imageAsset!,
                            height: 102,
                            width: 80,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 102,
                            width: 80,
                            color: AppColors.base3,
                            child: const Icon(
                              Icons.broken_image,
                              size: 28,
                              color: AppColors.base2,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 3,
                    child: GlobalsCard(
                      height: 16,
                      backgroundColor:
                          isAvailable ? AppColors.success1 : AppColors.warn1,
                      child: Row(
                        children: [
                          const SizedBox(width: 5),
                          if (effectiveShowChat)
                            SvgPicture.asset(
                              'assets/svg/chat-rounded.svg',
                              height: 8,
                              width: 8,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.base5, BlendMode.srcIn),
                            ),
                          if (effectiveShowChat && effectiveShowVideoCall)
                            const SizedBox(width: 2),
                          if (effectiveShowVideoCall)
                            SvgPicture.asset(
                              'assets/svg/ic_ video call.svg',
                              height: 8,
                              width: 8,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.base5, BlendMode.srcIn),
                            ),
                          if ((effectiveShowChat || effectiveShowVideoCall))
                            const SizedBox(width: 2),
                          Text(
                            isAvailable ? 'Tersedia' : 'Jadwal Penuh',
                            style: AppTextStyles.list3SemiBold(AppColors.base5),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalsCardOutlined(
                            borderColor: AppColors.secondary1,
                            height: 16,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: Text(
                                  ticketType!,
                                  style: AppTextStyles.list3SemiBold(
                                      AppColors.secondary1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GlobalsCardOutlined(
                            height: 16,
                            borderColor: _getRoleColor(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: Text(
                                  role,
                                  style: AppTextStyles.list3SemiBold(
                                      _getRoleColor()),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(doctorName, style: AppTextStyles.heading3SemiBold()),
                      Wrap(
                        spacing: 10,
                        runSpacing: 4,
                        children: infoItems.map((item) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 3.1,
                            child: GlobalsCard(
                              margin: const EdgeInsets.all(0),
                              radius: 4,
                              hasShadow: false,
                              height: 14,
                              backgroundColor: AppColors.base3,
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  SvgPicture.asset(
                                      height: 9,
                                      width: 9,
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.base1, BlendMode.srcIn),
                                      item['icon']!),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['text']!,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.list3Regular(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GlobalsButton(
                            elevation: 0,
                            color: AppColors.primary1,
                            height: 26,
                            width: MediaQuery.of(context).size.width / 3,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const JadwalKonsultasiPage(),
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    height: 12,
                                    width: 12,
                                    'assets/svg/ic_coupon - ticket.svg'),
                                const SizedBox(width: 2),
                                Text(
                                  'Gunakan',
                                  style:
                                      AppTextStyles.list1Bold(AppColors.base5),
                                )
                              ],
                            ),
                          ),
                          GlobalsButton(
                            elevation: 0,
                            color: AppColors.secondary1,
                            height: 26,
                            width: MediaQuery.of(context).size.width / 3,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PageScheduleCst(),
                                  ));
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    height: 12,
                                    width: 12,
                                    'assets/svg/ic_coupon - ticket.svg'),
                                const SizedBox(width: 2),
                                Text(
                                  'Jadwalkan',
                                  style:
                                      AppTextStyles.list1Bold(AppColors.base5),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width / 1.05,
            color: AppColors.base3,
          )
        ],
      ),
    );
  }
}
