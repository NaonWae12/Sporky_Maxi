import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dialog/globals_bottom_sheet.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/profile_content/cmp_parent_profile/daily_missions.dart';

// ===========================================================================
//  PageDailyActivity — Halaman "Aktivitas Harian & Loyalty Badge"
//  Tampil pertama kali: maskot gif + info.
//  Tombol "Jelajahi Misi Seru Hari Ini" membuka bottom sheet dua kategori.
// ===========================================================================
class PageDailyActivity extends StatelessWidget {
  final List<MissionData> dailyMissions;
  final List<MissionData> milestoneMissions;
  final int dailyPending; // jumlah tugas yang belum selesai
  final int dailyTotal;
  final String serverDate;
  final String timezone;

  const PageDailyActivity({
    super.key,
    required this.dailyMissions,
    this.milestoneMissions = const [],
    required this.dailyPending,
    required this.dailyTotal,
    this.serverDate = '',
    this.timezone = '',
  });

  double get _dailyProgress =>
      dailyTotal > 0 ? (dailyTotal - dailyPending) / dailyTotal : 0.0;

  // ── Bottom sheet ──────────────────────────────────────────────────────────
  void _showMissionsSheet(BuildContext context) {
    showAppBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      child: _MissionsBottomSheet(
        dailyMissions: dailyMissions,
        milestoneMissions: milestoneMissions,
        dailyPending: dailyPending,
        dailyTotal: dailyTotal,
        dailyProgress: _dailyProgress,
      ),
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      // ── AppBar ─────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.base5,
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.base1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Text(
              'Aktivitas Harian & Loyalty Badge',
              style: AppTextStyles.heading3SemiBold(AppColors.base1),
            ),
          ],
        ),
      ),
      // ── Body ──────────────────────────────────────────────────────────
      body: Column(
        children: [
          // Konten scrollable (maskot + info)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Maskot GIF ─────────────────────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/giff/gif1.gif',
                      width: 260,
                      height: 280,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 260,
                        decoration: BoxDecoration(
                          color: AppColors.base4,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: AppColors.base2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Judul ──────────────────────────────────────────────
                  Text(
                    'Makin aktif, makin banyak bonus!',
                    style: AppTextStyles.heading2SemiBold(AppColors.base1),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),

                  // Deskripsi dalam kotak abu ──────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.base4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Naikkan level badge dan dapatkan fitur ekstra yang bantu Bunda lebih mudah pantau si kecil.',
                      style: AppTextStyles.list1Regular(AppColors.base1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (serverDate.isNotEmpty || timezone.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Reset harian: ${serverDate.isEmpty ? '-' : serverDate} ${timezone.isEmpty ? '' : '($timezone)'}',
                      style: AppTextStyles.list3Regular(AppColors.base2),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Tombol sticky bawah ────────────────────────────────────────
          Container(
            color: AppColors.base5,
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: GlobalsButton(
              onPressed: dailyPending > 0
                  ? null
                  : () => _showMissionsSheet(context),
              color: dailyPending > 0 ? AppColors.base3 : AppColors.secondary1,
              height: 52,
              radius: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    color: AppColors.base5,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: GlobalsButtonText(
                      text: dailyPending > 0
                          ? 'Selesaikan $dailyPending Misi Dulu'
                          : 'Lihat Reward Misi Hari Ini',
                      style: AppTextStyles.heading3SemiBold(AppColors.base5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
//  _MissionsBottomSheet — Sheet berisi dua kategori misi
// ===========================================================================
class _MissionsBottomSheet extends StatefulWidget {
  final List<MissionData> dailyMissions;
  final List<MissionData> milestoneMissions;
  final int dailyPending;
  final int dailyTotal;
  final double dailyProgress;

  const _MissionsBottomSheet({
    required this.dailyMissions,
    required this.milestoneMissions,
    required this.dailyPending,
    required this.dailyTotal,
    required this.dailyProgress,
  });

  @override
  State<_MissionsBottomSheet> createState() => _MissionsBottomSheetState();
}

class _MissionsBottomSheetState extends State<_MissionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final milestoneTotal = widget.milestoneMissions.length;
    final milestoneClaimed = widget.milestoneMissions
        .where((mission) => mission.isClaimed)
        .length;
    final milestoneProgress = milestoneTotal > 0
        ? milestoneClaimed / milestoneTotal
        : 0.0;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Konten scrollable
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    // ══ Kategori 1: Misi Harian ═══════════════════════
                    _SectionHeader(
                      iconAsset: 'assets/svg/ic_list.svg',
                      title: 'Misi Harian',
                      iconColor: AppColors.primary1,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.dailyPending}/${widget.dailyTotal} Tugas Harian Tersisa',
                      style: AppTextStyles.list1Regular(AppColors.base2),
                    ),
                    const SizedBox(height: 8),
                    _ProgressBar(
                      value: widget.dailyProgress,
                      color: AppColors.primary1,
                    ),
                    const SizedBox(height: 16),

                    // Daftar misi harian
                    ...widget.dailyMissions.asMap().entries.map((e) {
                      final isLast = e.key == widget.dailyMissions.length - 1;
                      return _MissionSheetItem(
                        data: e.value,
                        showDivider: !isLast,
                        onTap: () => DailyTaskHandler.showActionHint(
                          context: context,
                          mission: e.value,
                        ),
                      );
                    }),

                    const SizedBox(height: 32),

                    // ══ Kategori 2: Misi Level-Up Loyalty Badge ════════
                    _SectionHeader(
                      icon: Icons.rocket_launch_rounded,
                      title: 'Misi Level-Up Loyalty Badge',
                      iconColor: AppColors.secondary1,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$milestoneClaimed/$milestoneTotal Milestone Tercapai',
                      style: AppTextStyles.list1Regular(AppColors.base2),
                    ),
                    const SizedBox(height: 8),
                    _ProgressBar(
                      value: milestoneProgress,
                      color: AppColors.secondary1,
                    ),
                    const SizedBox(height: 20),

                    if (widget.milestoneMissions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Belum ada milestone aktif dari server.',
                            style: AppTextStyles.list1Regular(AppColors.base2),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ...widget.milestoneMissions.asMap().entries.map((e) {
                        final isLast =
                            e.key == widget.milestoneMissions.length - 1;
                        return _MissionSheetItem(
                          data: e.value,
                          showDivider: !isLast,
                          showProgress: true,
                          onTap: () => DailyTaskHandler.showActionHint(
                            context: context,
                            mission: e.value,
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===========================================================================
//  Widget helper — Section Header
// ===========================================================================
class _SectionHeader extends StatelessWidget {
  final String? iconAsset;
  final IconData? icon;
  final String title;
  final Color iconColor;

  const _SectionHeader({
    this.iconAsset,
    this.icon,
    required this.title,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon: SVG atau Material icon
        SizedBox(
          width: 22,
          height: 22,
          child: iconAsset != null
              ? SvgPicture.asset(
                  iconAsset!,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  placeholderBuilder: (_) =>
                      const SizedBox(width: 22, height: 22),
                )
              : Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.heading3SemiBold(AppColors.base1),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
//  Widget helper — Progress Bar sederhana (non-interaktif)
// ===========================================================================
class _ProgressBar extends StatelessWidget {
  final double value; // 0.0 – 1.0
  final Color color;

  const _ProgressBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 8,
        backgroundColor: AppColors.base3,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

// ===========================================================================
//  Widget helper — Satu baris item misi di dalam bottom sheet
//  Tampil: icon | label | +Xp chip | status circle
// ===========================================================================
class _MissionSheetItem extends StatelessWidget {
  final MissionData data;
  final bool showDivider;
  final bool showProgress;
  final VoidCallback? onTap;

  const _MissionSheetItem({
    required this.data,
    this.showDivider = true,
    this.showProgress = false,
    this.onTap,
  });

  bool get _isClaimed => data.isClaimed;
  bool get _isCompleted => data.isCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Icon kategori ─────────────────────────────────────
                SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    data.iconAsset,
                    colorFilter: ColorFilter.mode(
                      data.iconColor,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (_) =>
                        const SizedBox(width: 20, height: 20),
                  ),
                ),
                const SizedBox(width: 10),

                // ── Label misi ────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.label,
                        style: AppTextStyles.list1Regular(AppColors.base1),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (showProgress && data.target > 0) ...[
                        const SizedBox(height: 6),
                        _ProgressBar(
                          value: data.percentage / 100,
                          color: data.isClaimed
                              ? AppColors.success2
                              : AppColors.secondary1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${data.current}/${data.target} • ${data.statusLabel}',
                          style: AppTextStyles.list3Regular(AppColors.base2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else if (!data.isClaimed && data.actionHint.isNotEmpty)
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

                // ── XP chip ──────────────────────────────────────────
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

                // ── Status circle ─────────────────────────────────────
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isClaimed
                        ? AppColors.success2
                        : _isCompleted
                        ? AppColors.primary1
                        : Colors.transparent,
                    border: _isClaimed || _isCompleted
                        ? null
                        : Border.all(color: AppColors.base3, width: 1.5),
                  ),
                  child: _isClaimed
                      ? const Icon(
                          Icons.check,
                          color: AppColors.base5,
                          size: 12,
                        )
                      : _isCompleted
                      ? const Icon(Icons.sync, color: AppColors.base5, size: 11)
                      : null,
                ),
              ],
            ),
          ),
        ),

        // Divider tipis antar item
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.base3.withAlpha(120),
          ),
      ],
    );
  }
}
