import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/profile_content/cmp_parent_profile/daily_missions.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

/// Popup "Misi Harian" yang muncul sekali per session aplikasi
/// (session = proses aplikasi berjalan, mirip Shopee yang refresh saat dibuka).
/// Bukan per-login: selama app tidak di-restart, popup hanya tampil sekali.
class DailyTasksPopup {
  static bool _shownThisSession = false;

  static void reset() => _shownThisSession = false;

  /// Tampilkan popup sekali per session. Aman dipanggil berkali-kali;
  /// kalau sudah pernah tampil di session ini, langsung no-op.
  static Future<void> showOncePerSession(BuildContext context) async {
    if (_shownThisSession) return;
    _shownThisSession = true;

    try {
      final pending = await fetchPendingTasks();
      if (!context.mounted) return;

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black54,
        builder: (_) => _DailyTasksPopupSheet(tasks: pending),
      );
    } catch (e) {
      debugPrint('[DailyTasksPopup] gagal memuat misi harian: $e');
    }
  }

  /// Ambil daftar daily task yang belum selesai hari ini (pending).
  static Future<List<MissionData>> fetchPendingTasks() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      return const [];
    }

    final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
    final response = await http.get(
      Uri.parse(ApiEndpoints.dailyTasks),
      headers: {'Authorization': authHeader, 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      return const [];
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final tasks = decoded['tasks'] as List? ?? [];

    return tasks
        .map((e) => MissionData.fromJson(e as Map<String, dynamic>))
        .where((m) => !m.isClaimed && !m.isCompleted)
        .toList();
  }
}

class _DailyTasksPopupSheet extends StatelessWidget {
  final List<MissionData> tasks;

  const _DailyTasksPopupSheet({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: const BoxDecoration(
          color: AppColors.base5,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.base3,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Daily Task Hari Ini',
                    style: AppTextStyles.heading3SemiBold(AppColors.base1),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.base2),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Yuk selesaikan misi berikut untuk kumpulkan XP!',
              style: AppTextStyles.list1Regular(AppColors.base2),
            ),
            const SizedBox(height: 16),

            // Daftar task pending
            if (tasks.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Semua misi hari ini sudah selesai. 🎉',
                    style: AppTextStyles.list1Bold(AppColors.primary1),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ] else
              ...tasks.map((task) => _DailyTaskRow(task: task)),

            const SizedBox(height: 20),

            // Tombol utama
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary1,
                  foregroundColor: AppColors.base5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Ayo Mulai',
                  style: AppTextStyles.heading3SemiBold(AppColors.base5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyTaskRow extends StatelessWidget {
  final MissionData task;

  const _DailyTaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.base4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          SizedBox(
            width: 22,
            height: 22,
            child: task.iconAsset.isNotEmpty
                ? SvgPicture.asset(
                    task.iconAsset,
                    colorFilter: ColorFilter.mode(
                      task.iconColor,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (_) =>
                        Icon(Icons.flag, color: task.iconColor, size: 22),
                  )
                : Icon(Icons.flag, color: task.iconColor, size: 22),
          ),
          const SizedBox(width: 10),

          // Label + periode
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.label,
                  style: AppTextStyles.list1Bold(AppColors.base1),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (task.periodLabel.isNotEmpty)
                  Text(
                    task.periodLabel,
                    style: AppTextStyles.list3SemiBold(AppColors.secondary2),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // XP chip
          if (task.points > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary3,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+${task.points}xp',
                style: AppTextStyles.list3SemiBold(AppColors.primary1),
              ),
            ),
        ],
      ),
    );
  }
}
