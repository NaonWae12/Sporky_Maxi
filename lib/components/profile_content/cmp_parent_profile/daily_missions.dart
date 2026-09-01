import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

// ---------------------------------------------------------------------------
// Model data misi — dipakai di profil & halaman aktivitas
// ---------------------------------------------------------------------------
class MissionData {
  final String uuid;
  final String taskUuid;
  final String category;
  final String categoryLabel;
  final String description;
  final String iconAsset;
  final Color iconColor;
  final String label;
  final int points;
  final int current;
  final int target;
  final double percentage;
  final String statusLabel;
  final String actionHint;
  final bool isMilestone;
  String status; // 'pending' | 'completed' | 'claimed'

  MissionData({
    this.uuid = '',
    this.taskUuid = '',
    this.category = '',
    this.categoryLabel = '',
    this.description = '',
    required this.iconAsset,
    required this.iconColor,
    required this.label,
    this.points = 0,
    this.current = 0,
    this.target = 0,
    this.percentage = 0,
    this.statusLabel = '',
    this.actionHint = '',
    this.isMilestone = false,
    this.status = 'pending',
  });

  bool get isClaimed => status == 'claimed';
  bool get isCompleted => status == 'completed';
  bool get isDone => isClaimed;
}

// ---------------------------------------------------------------------------
// Helper untuk memproses penyelesaian dan klaim task
// ---------------------------------------------------------------------------
class DailyTaskHandler {
  static void showActionHint({
    required BuildContext context,
    required MissionData mission,
  }) {
    final message = mission.isClaimed
        ? 'Misi ini sudah diklaim otomatis dari aktivitas nyata.'
        : mission.isCompleted
        ? 'Misi sudah selesai dan akan tersinkron otomatis.'
        : mission.actionHint.isNotEmpty
        ? mission.actionHint
        : 'Selesaikan aktivitas terkait agar misi diklaim otomatis.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
  final VoidCallback? onAllMissionsCompleted;

  const DailyMissions({
    super.key,
    this.missionCount = 0,
    this.totalCount = 0,
    required this.missions,
    this.onSeeAll,
    this.onAllMissionsCompleted,
  });

  @override
  State<DailyMissions> createState() => _DailyMissionsState();
}

class _DailyMissionsState extends State<DailyMissions> {
  @override
  void didUpdateWidget(covariant DailyMissions oldWidget) {
    super.didUpdateWidget(oldWidget);

    final missionsJustCompleted =
        widget.totalCount > 0 &&
        widget.missionCount == 0 &&
        oldWidget.missionCount > 0;

    if (missionsJustCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAllMissionsCompleted?.call();
      });
    }
  }

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
              onTap: () => DailyTaskHandler.showActionHint(
                context: context,
                mission: data,
              ),
            ),
          ),

          // ── Tombol navigasi (hanya jika ada lebih dari 5) ────────
          if (hasMore)
            Center(
              child: TextButton(
                onPressed: widget.totalCount > 0 && widget.missionCount == 0
                    ? null
                    : widget.onSeeAll,
                child: Text(
                  widget.totalCount > 0 && widget.missionCount == 0
                      ? 'Semua Misi Selesai'
                      : 'Lihat Selengkapnya',
                  style: AppTextStyles.list1Bold(
                    widget.totalCount > 0 && widget.missionCount == 0
                        ? AppColors.base2
                        : AppColors.primary1,
                  ),
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

  const MissionListItem({super.key, required this.data, this.onTap});

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
                    colorFilter: ColorFilter.mode(
                      data.iconColor,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (_) =>
                        const SizedBox(width: 16, height: 16),
                  ),
                ),
                const SizedBox(width: 8),

                // Label misi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.label,
                        style: AppTextStyles.list1Regular(AppColors.base1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!data.isClaimed && data.actionHint.isNotEmpty)
                        Text(
                          data.actionHint,
                          style: AppTextStyles.list3Regular(AppColors.base2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // XP Chip
                if (data.points > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary3,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 6,
                          color: AppColors.primary1,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '+${data.points}xp',
                          style: AppTextStyles.list3SemiBold(
                            AppColors.primary1,
                          ),
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
                    color: data.isClaimed
                        ? AppColors.success2
                        : data.isCompleted
                        ? AppColors.primary1
                        : Colors.transparent,
                    border: data.isClaimed || data.isCompleted
                        ? null
                        : Border.all(color: AppColors.base3, width: 1.5),
                  ),
                  child: data.isClaimed
                      ? const Icon(
                          Icons.check,
                          color: AppColors.base5,
                          size: 11,
                        )
                      : data.isCompleted
                      ? const Icon(Icons.sync, color: AppColors.base5, size: 10)
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
