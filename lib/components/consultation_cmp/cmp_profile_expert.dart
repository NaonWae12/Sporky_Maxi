import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';

import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class CmpProfileExpert extends StatelessWidget {
  final String? imageAsset;
  final String specialization;
  final String experience;
  final String workingDays;
  final String workingHours;
  final String price;
  final String starCount;
  final String role;
  final String doctorName;

  const CmpProfileExpert({
    super.key,
    this.imageAsset,
    this.specialization = '-',
    this.experience = '-',
    this.workingHours = '-',
    this.workingDays = '-',
    this.price = '-',
    this.starCount = '0.0',
    this.role = 'Dokter',
    required this.doctorName,
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
        'icon': 'assets/svg/ic_ doctor.svg',
        'text': specialization,
      },
      {
        'icon': 'assets/svg/ic_ work time_suitcase.svg',
        'text': '$experience Tahun',
      },
      {
        'icon': 'assets/svg/ic_ calendar - schedule.svg',
        'text': workingDays,
      },
      {
        'icon': 'assets/svg/ic_clock.svg',
        'text': workingHours,
      },
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageAsset != null
                ? Image.asset(
                    imageAsset!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.base3,
                    child: const Icon(Icons.broken_image,
                        size: 48, color: AppColors.base2),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        GlobalsCard(
            hasShadow: false,
            backgroundColor: AppColors.base4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlobalsCardOutlined(
                          borderColor: _getRoleColor(),
                          height: 16,
                          backgroundColor: AppColors.base5,
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
                        GlobalsCardOutlined(
                          height: 14,
                          borderColor: AppColors.warn1,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.warn1,
                                size: 10,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                starCount,
                                style: AppTextStyles.list3SemiBold(
                                    AppColors.warn1),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      doctorName,
                      style: AppTextStyles.heading1SemiBold(),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: infoItems.map((item) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2.38,
                          child: GlobalsCard(
                            margin: const EdgeInsets.all(0),
                            radius: 8,
                            hasShadow: false,
                            height: 30,
                            backgroundColor: AppColors.base5,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                    height: 9,
                                    width: 9,
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.base1, BlendMode.srcIn),
                                    item['icon']!),
                                const SizedBox(width: 4),
                                Text(
                                  item['text']!,
                                  style: AppTextStyles.list3Regular(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    GlobalsCard(
                        margin: const EdgeInsets.all(0),
                        height: 30,
                        radius: 8,
                        hasShadow: false,
                        backgroundColor: AppColors.base5,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                                height: 13,
                                width: 13,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.base1, BlendMode.srcIn),
                                'assets/svg/ic_coupon - ticket.svg'),
                            const SizedBox(width: 5),
                            Text(
                              price,
                              style: AppTextStyles.list1Bold(),
                            )
                          ],
                        )),
                  ]),
            ))
      ],
    );
  }
}
