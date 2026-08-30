import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/currency/currency_formatter.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/consultation_ticket_session_launcher.dart';
import 'package:sporky_maxi/models/components/payment/transaction_model.dart';

import 'consultation_ticket_status.dart';

class ConsultationTicketCard extends StatelessWidget {
  final AppTransaction transaction;
  final ConsultationTicketStatus ticketStatus;
  final VoidCallback? onTap;
  final VoidCallback? onPrimaryAction;

  const ConsultationTicketCard({
    super.key,
    required this.transaction,
    required this.ticketStatus,
    this.onTap,
    this.onPrimaryAction,
  });

  String get _doctorName {
    final name = transaction.expert?.name.trim() ?? '';
    return name.isEmpty ? 'Dokter Sporky' : name;
  }

  String get _role => transaction.expert?.displayRole ?? 'Expert';

  String get _typeLabel {
    final type = transaction.consultationType.toLowerCase().trim();
    if (type == 'zoom') return 'Zoom';
    if (type == 'chat') return 'Chat';
    return type.isEmpty ? 'Konsultasi' : type;
  }

  String get _paymentStatusLabel {
    switch (transaction.status.toLowerCase().trim()) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'completed':
        return 'Pembayaran Berhasil';
      case 'failed':
        return 'Pembayaran Gagal';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return transaction.status.isEmpty ? '-' : transaction.status;
    }
  }

  Color get _statusColor {
    switch (ticketStatus) {
      case ConsultationTicketStatus.notYet:
        return AppColors.warn1;
      case ConsultationTicketStatus.schedule:
        return AppColors.primary1;
      case ConsultationTicketStatus.finish:
        return AppColors.success2;
    }
  }

  String get _scheduleText {
    final date = transaction.consultationDate;
    if (date == null) return 'Jadwal belum tersedia';
    return DateFormat('dd MMM yyyy, HH.mm').format(date.toLocal());
  }

  String get _expiresText {
    final date = transaction.expiresAt;
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date.toLocal());
  }

  String get _workingDays {
    final days = transaction.expert?.availableDays ?? const <String>[];
    return days.isEmpty ? '-' : days.join(', ');
  }

  String get _workingHours {
    final expert = transaction.expert;
    final direct = expert?.availableHours?.trim() ?? '';
    if (direct.isNotEmpty) return direct;

    final start = expert?.availableTimeStart?.trim() ?? '';
    final end = expert?.availableTimeEnd?.trim() ?? '';
    if (start.isNotEmpty && end.isNotEmpty) return '$start - $end';
    return start.isNotEmpty ? start : (end.isNotEmpty ? end : '-');
  }

  String get _durationText {
    final duration = transaction.resolvedConsultationProduct?.duration ?? 0;
    return duration <= 0 ? '-' : '$duration menit';
  }

  @override
  Widget build(BuildContext context) {
    final canJoin = ConsultationTicketSessionLauncher.canOpenSession(
      transaction,
    );

    return GlobalsCard(
      onTap: onTap,
      hasShadow: false,
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ExpertPhoto(photoUrl: transaction.expert?.photo),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Chip(label: _typeLabel, color: AppColors.secondary1),
                        const SizedBox(width: 8),
                        _Chip(label: _role, color: _roleColor),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _doctorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading3SemiBold(),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _InfoChip(
                          icon: 'assets/svg/ic_ calendar - schedule.svg',
                          text: _scheduleText,
                        ),
                        _InfoChip(
                          icon: 'assets/svg/ic_clock.svg',
                          text: _durationText,
                        ),
                        _InfoChip(
                          icon: 'assets/svg/ic_coupon - ticket.svg',
                          text: formatRupiah(transaction.totalAmount),
                        ),
                        _InfoChip(
                          icon: 'assets/svg/ic_ calendar - schedule.svg',
                          text: 'Berlaku: $_expiresText',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _paymentStatusLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.list1Bold(_statusColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GlobalsButton(
                          elevation: 0,
                          color: canJoin
                              ? AppColors.primary1
                              : AppColors.secondary1,
                          height: 30,
                          width: 118,
                          radius: 10,
                          onPressed: onPrimaryAction,
                          customTextStyle: AppTextStyles.list1Bold(
                            AppColors.base5,
                          ),
                          text: ConsultationTicketSessionLauncher.actionLabel(
                            transaction,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SmallText(label: 'Hari', value: _workingDays),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallText(label: 'Jam', value: _workingHours),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 2, color: AppColors.base3),
        ],
      ),
    );
  }

  Color get _roleColor {
    switch (_role.toLowerCase()) {
      case 'dokter':
        return AppColors.secondary2;
      case 'ahli gizi':
        return AppColors.primary1;
      default:
        return AppColors.base2;
    }
  }
}

class _ExpertPhoto extends StatelessWidget {
  final String? photoUrl;

  const _ExpertPhoto({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final photo = photoUrl?.trim() ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(height: 112, width: 84, child: _buildPhoto(photo)),
    );
  }

  Widget _buildPhoto(String photo) {
    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      return Image.network(
        photo,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _PhotoFallback(),
      );
    }

    if (photo.startsWith('assets/')) {
      return Image.asset(
        photo,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _PhotoFallback(),
      );
    }

    return const _PhotoFallback();
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.base3,
      child: const Icon(Icons.person, color: AppColors.base2, size: 34),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlobalsCardOutlined(
      height: 18,
      borderColor: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Text(label, style: AppTextStyles.list3SemiBold(color)),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2.55,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.base4,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 10,
            width: 10,
            colorFilter: const ColorFilter.mode(
              AppColors.base1,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.list3Regular(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallText extends StatelessWidget {
  final String label;
  final String value;

  const _SmallText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppTextStyles.list1Regular(AppColors.base1),
        children: [
          TextSpan(
            text: '$label: ',
            style: AppTextStyles.list1Bold(AppColors.base1),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
