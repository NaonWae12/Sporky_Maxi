import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../globals/card/globals_card.dart';
import '../../globals/card/globals_card_outlined.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/text_style.dart';

class ProgresSection extends StatefulWidget {
  final String badgeImg;
  final Key? refreshKey;

  const ProgresSection({
    super.key,
    required this.badgeImg,
    this.refreshKey,
  });

  @override
  State<ProgresSection> createState() => ProgresSectionState();
}

class ProgresSectionState extends State<ProgresSection> {
  int _total = 5;
  int _completed = 0;
  int _claimed = 0;
  double _percentage = 0.0; // 0.0 - 100.0

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  @override
  void didUpdateWidget(covariant ProgresSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshKey != oldWidget.refreshKey) {
      fetchProgress();
    }
  }

  Future<void> fetchProgress() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(ApiEndpoints.dailyTasksProgress),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final progress = decoded['progress'] as Map<String, dynamic>? ?? {};

        if (mounted) {
          setState(() {
            _total = int.tryParse(progress['total']?.toString() ?? '') ?? 5;
            _completed = int.tryParse(progress['completed']?.toString() ?? '') ?? 0;
            _claimed = int.tryParse(progress['claimed']?.toString() ?? '') ?? 0;
            _percentage = double.tryParse(progress['percentage']?.toString() ?? '') ?? 0.0;
          });
        }
      }
    } catch (e) {
      debugPrint('[ProgresSection] Error fetching progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung persentase faktor untuk FractionallySizedBox (0.0 - 1.0)
    final double widthFactor = (_percentage / 100.0).clamp(0.0, 1.0);
    final int currentXp = (_percentage * 10).round(); // Menampilkan kalkulasi XP dari persentase

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
                          '${_claimed * 500} Koin',
                          style: AppTextStyles.list3Bold(AppColors.primary1),
                        ),
                      ],
                    ),
                  ),
                  // XP Progress
                  Row(
                    children: [
                      Text(
                        '$currentXp',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Text('xp', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 12),
                      Text(
                        '($_completed/$_total Selesai)',
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
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
                  child: Image.asset(height: 32, width: 32, widget.badgeImg))
            ],
          ),

          const SizedBox(height: 8),

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

                // Filled progress dari API percentage
                Align(
                  alignment: Alignment.topLeft,
                  child: FractionallySizedBox(
                    widthFactor: widthFactor == 0 ? 0.02 : widthFactor,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Milestone indicators (persentase / milestone)
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [20, 40, 60, 80, 100].map((value) {
                      final isReached = _percentage >= value;

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
                            '$value%',
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
