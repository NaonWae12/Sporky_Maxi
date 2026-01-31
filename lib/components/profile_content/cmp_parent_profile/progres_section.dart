import 'package:flutter/material.dart';

import '../../globals/card/globals_card.dart';
import '../../globals/card/globals_card_outlined.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/text_style.dart';

class ProgresSection extends StatelessWidget {
  final String badgeImg;
  const ProgresSection({
    super.key,
    required this.badgeImg,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      backgroundColor: AppColors.base5,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas: Koin + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalsCardOutlined(
                    borderColor: AppColors.primary1,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          '3000 Koin',
                          style: AppTextStyles.list3Bold(AppColors.primary1),
                        ),
                      ],
                    ),
                  ),
                  // XP Progress
                  const Row(
                    children: [
                      Text(
                        '400',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Text('xp', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              GlobalsCard(
                  margin: const EdgeInsets.all(0),
                  backgroundColor: AppColors.base5,
                  radius: 8,
                  border: Border.all(color: AppColors.primary1, width: 2),
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(height: 32, width: 32, badgeImg))
            ],
          ),

          // Progress bar + milestones
          SizedBox(
            height: 37,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background progress bar
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.base4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),

                // Filled progress
                Align(
                  alignment: Alignment.topLeft,
                  child: FractionallySizedBox(
                    widthFactor: 400 / 1000,
                    child: Container(
                      height: 16, // << Naikin di sini bre
                      decoration: BoxDecoration(
                        color: AppColors.primary1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                // Milestone indicators
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [200, 400, 600, 800, 1000].map((value) {
                      final isReached = value <= 400;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isReached)
                                const SizedBox(
                                  height: 16,
                                  child: Icon(
                                    Icons.circle_outlined,
                                    size: 16,
                                    color: AppColors.base5,
                                  ),
                                )
                              else
                                const SizedBox(
                                  height: 16,
                                  child: Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: AppColors.primary1,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$value',
                            style: AppTextStyles.list1Regular(
                                isReached ? AppColors.base1 : AppColors.base2),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
