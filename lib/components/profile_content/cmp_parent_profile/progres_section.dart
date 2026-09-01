import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/dialog/sporky_dialog.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../globals/card/globals_card.dart';
import '../../globals/card/globals_card_outlined.dart';
import '../../globals/colors/colors.dart';
import '../../globals/text/text_style.dart';

class ProgresSection extends StatefulWidget {
  final String badgeImg;
  final Key? refreshKey;

  const ProgresSection({super.key, required this.badgeImg, this.refreshKey});

  @override
  State<ProgresSection> createState() => ProgresSectionState();
}

class ProgresSectionState extends State<ProgresSection> {
  int _taskTotal = 0;
  int _taskCompleted = 0;
  int _currentXp = 0;
  int _xpNeeded = 0;
  double _badgeProgressPercentage = 0.0; // 0.0 - 100.0
  String _activeBadgeName = 'Belum ada badge';
  String _nextBadgeName = '';
  String _activeBadgeImage = '';
  int _activeBadgeMinXp = 0;
  int _nextBadgeMinXp = 0;

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
        Uri.parse(ApiEndpoints.dailyTasks),
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final progress = decoded['progress'] as Map<String, dynamic>? ?? {};
        final loyalty = decoded['loyalty'] as Map<String, dynamic>? ?? {};
        final activeBadge =
            loyalty['active_badge'] as Map<String, dynamic>? ?? {};
        final nextBadge = loyalty['next_badge'] as Map<String, dynamic>? ?? {};

        if (mounted) {
          setState(() {
            _taskTotal = int.tryParse(progress['total']?.toString() ?? '') ?? 0;
            _taskCompleted =
                int.tryParse(progress['completed']?.toString() ?? '') ?? 0;
            _currentXp =
                int.tryParse(loyalty['current_xp']?.toString() ?? '') ?? 0;
            _badgeProgressPercentage =
                double.tryParse(
                  loyalty['progress_percentage']?.toString() ?? '',
                ) ??
                0.0;
            _activeBadgeName =
                activeBadge['name']?.toString() ?? 'Belum ada badge';
            _activeBadgeImage = activeBadge['image']?.toString() ?? '';
            _activeBadgeMinXp =
                int.tryParse(activeBadge['min_xp']?.toString() ?? '') ?? 0;
            _nextBadgeName = nextBadge['name']?.toString() ?? '';
            _nextBadgeMinXp =
                int.tryParse(nextBadge['min_xp']?.toString() ?? '') ?? 0;
            _xpNeeded =
                int.tryParse(nextBadge['xp_needed']?.toString() ?? '') ?? 0;
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
    final double widthFactor = (_badgeProgressPercentage / 100.0).clamp(
      0.0,
      1.0,
    );

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalsCardOutlined(
                      borderColor: AppColors.primary1,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_currentXp XP',
                            style: AppTextStyles.list3Bold(AppColors.primary1),
                          ),
                        ],
                      ),
                    ),
                    // XP Progress
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '$_currentXp',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('xp', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 12),
                        Text(
                          '($_taskCompleted/$_taskTotal Misi Harian)',
                          style: AppTextStyles.list1Regular(AppColors.base2),
                        ),
                      ],
                    ),
                    Text(
                      _nextBadgeName.isEmpty
                          ? _activeBadgeName
                          : 'Next: $_nextBadgeName • $_xpNeeded XP lagi',
                      style: AppTextStyles.list3Regular(AppColors.base2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GlobalsCard(
                margin: const EdgeInsets.all(0),
                backgroundColor: AppColors.base5,
                radius: 8,
                border: Border.all(color: AppColors.primary1, width: 2),
                padding: const EdgeInsets.all(4),
                onTap: _showBadgeDialog,
                child: _buildBadgeImage(),
              ),
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
                      final isReached = _badgeProgressPercentage >= value;

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
                              isReached ? AppColors.base1 : AppColors.base2,
                            ),
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

  void _showBadgeDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => SporkyDialog(
        title: _activeBadgeName,
        message: _nextBadgeName.isEmpty
            ? 'Bunda sudah mencapai level tertinggi Sporky Maxi. Terus pertahankan aktivitas sehat si kecil.'
            : 'Level saat ini dimulai dari $_activeBadgeMinXp XP. Lanjutkan $_xpNeeded XP lagi untuk mencapai $_nextBadgeName ($_nextBadgeMinXp XP).',
        actions: [
          SporkyDialogAction(
            label: 'Mengerti',
            isPrimary: true,
            onPressed: () => Navigator.pop(dialogContext),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeImage() {
    if (_activeBadgeImage.startsWith('http')) {
      return Image.network(
        _activeBadgeImage,
        height: 32,
        width: 32,
        errorBuilder: (_, __, ___) => _badgeFallback(),
      );
    }

    return Image.asset(
      widget.badgeImg,
      height: 32,
      width: 32,
      errorBuilder: (_, __, ___) => _badgeFallback(),
    );
  }

  Widget _badgeFallback() {
    return const Icon(
      Icons.workspace_premium_rounded,
      color: AppColors.primary1,
      size: 32,
    );
  }
}
