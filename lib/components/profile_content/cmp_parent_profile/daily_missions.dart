import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/dialog/dialog_alert.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

// ---------------------------------------------------------------------------
// Model data misi — dipakai di profil & halaman aktivitas
// ---------------------------------------------------------------------------
class MissionData {
  final String uuid;
  final String iconAsset;
  final Color iconColor;
  final String label;
  final int points;
  String status; // 'pending' | 'completed' | 'claimed'

  MissionData({
    this.uuid = '',
    required this.iconAsset,
    required this.iconColor,
    required this.label,
    this.points = 0,
    this.status = 'pending',
  });

  bool get isDone => status == 'completed' || status == 'claimed';
}

// ---------------------------------------------------------------------------
// Helper untuk memproses penyelesaian dan klaim task
// ---------------------------------------------------------------------------
class DailyTaskHandler {
  static Future<void> completeAndClaim({
    required BuildContext context,
    required MissionData mission,
    VoidCallback? onSuccess,
  }) async {
    if (mission.status == 'claimed') {
      return;
    }

    if (mission.uuid.isEmpty) {
      debugPrint('[DailyTaskHandler] ERROR: mission.uuid is empty!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID Misi tidak valid')),
      );
      return;
    }

    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary1),
      ),
    );

    try {
      final token = await SecureStorageService.getToken() ?? '';
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final headers = {
        'Authorization': authHeader,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // debugPrint('[DailyTaskHandler] Starting flow for task UUID: ${mission.uuid}');
      // debugPrint('[DailyTaskHandler] Mission status: ${mission.status}');

      bool completeSuccess = true;
      String completeErrorMessage = '';

      if (mission.status == 'pending') {
        final completeUrl = ApiEndpoints.completeTask(mission.uuid);
        debugPrint('[DailyTaskHandler] POST Complete URL: $completeUrl');

        final completeRes = await http.post(
          Uri.parse(completeUrl),
          headers: headers,
          body: jsonEncode({}),
        );

        // debugPrint('[DailyTaskHandler] Complete Response Status: ${completeRes.statusCode}');
        // debugPrint('[DailyTaskHandler] Complete Response Body: ${completeRes.body}');

        dynamic completeData;
        try {
          completeData = jsonDecode(completeRes.body);
        } catch (_) {}

        completeSuccess = completeRes.statusCode == 200 ||
            completeRes.statusCode == 201 ||
            (completeData is Map && completeData['success'] == true);

        if (!completeSuccess) {
          completeErrorMessage =
              (completeData is Map ? completeData['message'] : null) ??
                  'HTTP ${completeRes.statusCode}: Gagal menyelesaikan tugas';
        }
      }

      if (completeSuccess) {
        final claimUrl = ApiEndpoints.claimTask(mission.uuid);
        // debugPrint('[DailyTaskHandler] POST Claim URL: $claimUrl');

        final claimRes = await http.post(
          Uri.parse(claimUrl),
          headers: headers,
          body: jsonEncode({}),
        );

        // debugPrint('[DailyTaskHandler] Claim Response Status: ${claimRes.statusCode}');
        // debugPrint('[DailyTaskHandler] Claim Response Body: ${claimRes.body}');

        dynamic claimData;
        try {
          claimData = jsonDecode(claimRes.body);
        } catch (_) {}

        if (context.mounted) Navigator.pop(context); // Tutup loading dialog

        final claimSuccess = claimRes.statusCode == 200 ||
            claimRes.statusCode == 201 ||
            (claimData is Map && claimData['success'] == true);

        if (claimSuccess) {
          mission.status = 'claimed';
          final pointsEarned = (claimData is Map && claimData['data'] is Map)
              ? claimData['data']['points_earned'] ?? mission.points
              : mission.points;
          if (context.mounted) {
            DialogAlert.show(
              context: context,
              barrierDismissible: true,
              child: Content1(
                title: 'Misi Berhasil!',
                message:
                    'Selamat! Kamu berhasil menyelesaikan misi dan mendapatkan +$pointsEarned XP!',
                image: 'assets/giff/gif1.gif',
                iconAsset: 'assets/svg/ic_success.svg',
                textNav: 'Lanjutkan',
                onPressed: () {
                  Navigator.pop(context);
                  if (onSuccess != null) onSuccess();
                },
              ),
            );
          }
        } else {
          final errStr = (claimData is Map ? claimData['message'] : null) ??
              'HTTP ${claimRes.statusCode}: Gagal mengklaim poin misi';
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errStr)),
            );
          }
        }
      } else {
        if (context.mounted) Navigator.pop(context); // Tutup loading dialog
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(completeErrorMessage)),
          );
        }
      }
    } catch (e, stack) {
      debugPrint('[DailyTaskHandler] EXCEPTION: $e');
      debugPrint('[DailyTaskHandler] STACK: $stack');
      if (context.mounted) Navigator.pop(context); // Tutup loading dialog
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Widget ringkas di halaman profil (maks 5 item)
// Navigasi ditangani oleh parent lewat callback [onSeeAll]
// ---------------------------------------------------------------------------
class DailyMissions extends StatefulWidget {
  final int missionCount; // jumlah tugas pending/tersisa
  final int totalCount;
  final List<MissionData> missions;
  final VoidCallback? onSeeAll;
  final VoidCallback? onTaskCompleted;

  const DailyMissions({
    super.key,
    this.missionCount = 0,
    this.totalCount = 0,
    required this.missions,
    this.onSeeAll,
    this.onTaskCompleted,
  });

  @override
  State<DailyMissions> createState() => _DailyMissionsState();
}

class _DailyMissionsState extends State<DailyMissions> {
  @override
  Widget build(BuildContext context) {
    final displayedMissions = widget.missions.take(5).toList();
    final hasMore = widget.missions.length > 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              SvgPicture.asset('assets/svg/ic_list.svg'),
              const SizedBox(width: 5),
              Text(
                'Misi Hari Ini',
                style: AppTextStyles.heading3SemiBold(AppColors.primary1),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '${widget.missionCount}/${widget.totalCount} Tugas Harian Tersisa',
              style: AppTextStyles.list1Bold(AppColors.base2),
            ),
          ),
          const SizedBox(height: 4),

          // ── List (max 5) ─────────────────────────────────────────
          ...displayedMissions.map(
            (data) => MissionListItem(
              data: data,
              onTap: () {
                if (!data.isDone) {
                  DailyTaskHandler.completeAndClaim(
                    context: context,
                    mission: data,
                    onSuccess: () {
                      if (mounted) setState(() {});
                      widget.onTaskCompleted?.call();
                    },
                  );
                }
              },
            ),
          ),

          // ── Tombol navigasi (hanya jika ada lebih dari 5) ────────
          if (hasMore)
            Center(
              child: TextButton(
                onPressed: widget.onSeeAll,
                child: Text(
                  'Lihat Selengkapnya',
                  style: AppTextStyles.list1Bold(AppColors.primary1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Item misi kecil di profil (icon + label + XP chip + status checkmark + divider)
// ---------------------------------------------------------------------------
class MissionListItem extends StatelessWidget {
  final MissionData data;
  final VoidCallback? onTap;

  const MissionListItem({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                // SVG icon dibungkus SizedBox agar layout stabil
                SizedBox(
                  width: 16,
                  height: 16,
                  child: SvgPicture.asset(
                    data.iconAsset,
                    colorFilter:
                        ColorFilter.mode(data.iconColor, BlendMode.srcIn),
                    placeholderBuilder: (_) =>
                        const SizedBox(width: 16, height: 16),
                  ),
                ),
                const SizedBox(width: 8),

                // Label misi
                Expanded(
                  child: Text(
                    data.label,
                    style: AppTextStyles.list1Regular(AppColors.base1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),

                // XP Chip
                if (data.points > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary3,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle,
                            size: 6, color: AppColors.primary1),
                        const SizedBox(width: 3),
                        Text(
                          '+${data.points}xp',
                          style:
                              AppTextStyles.list3SemiBold(AppColors.primary1),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),

                // Status Circle / Checkmark
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        data.isDone ? AppColors.success2 : Colors.transparent,
                    border: data.isDone
                        ? null
                        : Border.all(color: AppColors.base3, width: 1.5),
                  ),
                  child: data.isDone
                      ? const Icon(Icons.check,
                          color: AppColors.base5, size: 11)
                      : null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width / 1.05,
          color: AppColors.primary3,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
