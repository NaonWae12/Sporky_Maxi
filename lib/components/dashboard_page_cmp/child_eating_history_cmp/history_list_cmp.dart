import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class HistoryListCmp extends StatelessWidget {
  final String? mealTime;
  final String? historyDay;
  final String hour;
  final String? imageAsset1;
  final String? imageAsset2;
  final int carbohydrate;
  final int proteins;
  final int fat;
  final String itemName;
  final int totalcalories;
  final VoidCallback? onTap;

  const HistoryListCmp({
    super.key,
    this.mealTime,
    this.historyDay,
    required this.hour,
    this.imageAsset1,
    this.imageAsset2,
    required this.carbohydrate,
    required this.proteins,
    required this.fat,
    required this.itemName,
    required this.totalcalories,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mealTime != null && mealTime!.isNotEmpty)
                    Text(
                      mealTime!,
                      style: AppTextStyles.heading3SemiBold(
                        _getBorderColor(mealTime!),
                      ),
                    ),
                  if (historyDay != null && historyDay!.isNotEmpty)
                    Text(
                      historyDay!,
                      style: AppTextStyles.heading3SemiBold(AppColors.base1),
                    ),
                ],
              ),
              Text(hour, style: AppTextStyles.list1Regular()),
            ],
          ),
        ),
        Center(
          child: Container(
            height: 2,
            width: MediaQuery.of(context).size.width / 1.05,
            color: AppColors.base2,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10, right: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        const SizedBox(
                          height: 100,
                          width: 75,
                        ),
                        Positioned(
                          left: 16,
                          top: 15,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.base5, width: 2)),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: imageAsset1 != null
                                  ? Image.asset(
                                      imageAsset1!,
                                      height: 57,
                                      width: 46,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 57,
                                      width: 46,
                                      color: AppColors.base3,
                                      child: const Icon(Icons.broken_image,
                                          size: 15, color: AppColors.base2),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    color: AppColors.base5, width: 2)),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: imageAsset1 != null
                                  ? Image.asset(
                                      imageAsset1!,
                                      height: 57,
                                      width: 46,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 57,
                                      width: 46,
                                      color: AppColors.base3,
                                      child: const Icon(Icons.broken_image,
                                          size: 15, color: AppColors.base2),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GlobalsCard(
                                hasShadow: false,
                                backgroundColor: AppColors.base4,
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/ic_nutrition.svg'),
                                    Text('$carbohydrate gr',
                                        style: AppTextStyles.list3Regular()),
                                  ],
                                )),
                            GlobalsCard(
                                hasShadow: false,
                                backgroundColor: AppColors.base4,
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/ic_proteins.svg'),
                                    Text('$proteins gr',
                                        style: AppTextStyles.list3Regular()),
                                  ],
                                )),
                            GlobalsCard(
                                hasShadow: false,
                                backgroundColor: AppColors.base4,
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset('assets/svg/ic_fat.svg'),
                                    Text('$fat gr',
                                        style: AppTextStyles.list3Regular()),
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            itemName,
                            style: AppTextStyles.list1Regular(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GlobalsCard(
                    backgroundColor: AppColors.base4,
                    radius: 16,
                    hasShadow: false,
                    margin: const EdgeInsets.only(right: 10, bottom: 18),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                            height: 16, width: 16, 'assets/svg/ic_fire.svg'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6.3,
                          child: Text(
                            '$totalcalories kcal',
                            style: AppTextStyles.list1Bold(),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}

Color _getBorderColor(String category) {
  switch (category.toLowerCase()) {
    case "makan pagi":
      return AppColors.primary1;
    case "makan siang":
      return AppColors.warn1;
    case "makan malam":
      return AppColors.secondary1;
    case "cemilan pagi":
      return AppColors.info1;
    case "cemilan sore":
      return AppColors.info1;
    default:
      // Pilih 1 dari 4 warna alternatif secara random
      final random = Random();
      final fallbackColors = [
        AppColors.primary2, // kuning terang
        AppColors.secondary2, // biru sangat muda
        AppColors.warn2, // merah peach
        AppColors.success1, // hijau terang
      ];
      return fallbackColors[random.nextInt(fallbackColors.length)];
  }
}
