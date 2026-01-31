import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';

class ChildProfileSection extends StatelessWidget {
  final String childName;
  final int ageYear;
  final int ageMonth;
  final String status;
  final int score;
  // final VoidCallback onDashboardTap;
  final int tb;
  final int bb;
  final double width;

  const ChildProfileSection({
    super.key,
    required this.childName,
    required this.ageYear,
    required this.ageMonth,
    required this.status,
    required this.score,
    // required this.onDashboardTap,
    required this.tb,
    required this.bb,
    this.width = 372,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: width,
      child: GlobalsCard(
        backgroundColor: AppColors.primary3,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar anak
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary2,
                  backgroundImage: AssetImage('assets/temp_img/kids.png'),
                ),
                const SizedBox(width: 12),
                // Info Anak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        childName,
                        style: AppTextStyles.heading1SemiBold(AppColors.base1),
                      ),
                      const SizedBox(height: 4),
                      // TB/BB anak
                      Row(
                        children: [
                          GlobalsCardOutlined(
                            label: 'TB',
                            value: '$tb',
                            unit: 'cm',
                          ),
                          const SizedBox(width: 8),
                          GlobalsCardOutlined(
                            label: 'BB',
                            value: '$bb',
                            unit: 'kg',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.base1,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Umur: ',
                                    style: AppTextStyles.list1Regular(
                                        AppColors.base5),
                                  ),
                                  TextSpan(
                                    text: '$ageYear',
                                    style: AppTextStyles.list1Bold(
                                        AppColors.base5),
                                  ),
                                  TextSpan(
                                    text: ' thn ',
                                    style: AppTextStyles.list1Regular(
                                        AppColors.base5),
                                  ),
                                  TextSpan(
                                    text: '$ageMonth',
                                    style: AppTextStyles.list1Bold(
                                        AppColors.base5),
                                  ),
                                  TextSpan(
                                    text: ' bln',
                                    style: AppTextStyles.list1Regular(
                                        AppColors.base5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary1,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 9.8,
                              child: Text(
                                status,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.list1Bold(AppColors.base5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Score kal
                Container(
                  height:
                      60, // lebih besar supaya progress indicator proporsional
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.base5,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 6.0,
                      percent: 0.33,
                      progressColor: AppColors.primary1,
                      backgroundColor: AppColors.base3,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Text(
                              '$score',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.heading2SemiBold(
                                      AppColors.base1)
                                  .copyWith(height: 1),
                            ),
                          ),
                          Text(
                            'kal',
                            style: AppTextStyles.lable4Regular(AppColors.base1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 16),
            // GlobalsButton(
            //   onPressed: onDashboardTap,
            //   width: double.infinity,
            //   height: 23,
            //   color: AppColors.base5,
            //   textColor: AppColors.primary1,
            //   elevation: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("Lihat Dashboard", style: AppTextStyles.list1Medium()),
            //       const SizedBox(width: 8),
            //       const Icon(
            //         Icons.arrow_forward_ios,
            //         size: 10,
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
