import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/consultation_cmp/ticket_consultation_cmp/consultation_ticket_status.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/currency/currency_formatter.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/consultation_ticket_session_launcher.dart';
import 'package:sporky_maxi/models/components/payment/transaction_model.dart';

class PageDetailTicketCst extends StatelessWidget {
  final AppTransaction transaction;
  final ConsultationTicketStatus ticketStatus;

  const PageDetailTicketCst({
    super.key,
    required this.transaction,
    required this.ticketStatus,
  });

  String get _doctorName {
    final name = transaction.expert?.name.trim() ?? '';
    return name.isEmpty ? 'Dokter Sporky' : name;
  }

  String get _typeLabel {
    final type = transaction.consultationType.toLowerCase().trim();
    if (type == 'zoom') return 'Zoom';
    if (type == 'chat') return 'Chat';
    return type.isEmpty ? 'Konsultasi' : type;
  }

  String get _consultationStatus {
    final status = transaction.consultation?.status.toLowerCase().trim() ?? '';
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Terjadwal';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status.isEmpty ? '-' : status;
    }
  }

  String get _paymentStatus {
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

  String get _scheduleText => _formatDateTime(transaction.consultationDate);

  String get _buyDateText => _formatDateTime(transaction.date);

  String get _expiredText => _formatDate(transaction.expiresAt);

  String get _durationText {
    final duration = transaction.resolvedConsultationProduct?.duration ?? 0;
    return duration <= 0 ? '-' : '$duration menit';
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

  String _formatDateTime(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('dd MMM yyyy, HH.mm').format(value.toLocal());
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('dd MMM yyyy').format(value.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final canJoin = ConsultationTicketSessionLauncher.canOpenSession(
      transaction,
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text('Detail Tiket', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlobalsCard(
              hasShadow: false,
              backgroundColor: AppColors.base4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Konsultasi $_typeLabel',
                    style: AppTextStyles.heading2SemiBold(AppColors.base1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _doctorName,
                    style: AppTextStyles.heading3SemiBold(AppColors.base1),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Status Tiket', value: ticketStatus.title),
                  _DetailRow(label: 'Status Pembayaran', value: _paymentStatus),
                  _DetailRow(label: 'Status Sesi', value: _consultationStatus),
                  _DetailRow(label: 'Jadwal', value: _scheduleText),
                  _DetailRow(label: 'Durasi', value: _durationText),
                  _DetailRow(label: 'Berlaku Hingga', value: _expiredText),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GlobalsCard(
              hasShadow: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Pembelian',
                    style: AppTextStyles.heading3SemiBold(AppColors.base1),
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Order ID', value: transaction.orderId),
                  _DetailRow(label: 'Transaksi', value: transaction.uuid),
                  _DetailRow(label: 'Tanggal Beli', value: _buyDateText),
                  _DetailRow(
                    label: 'Metode Bayar',
                    value: transaction.paymentMethod.isEmpty
                        ? '-'
                        : transaction.paymentMethod,
                  ),
                  _DetailRow(
                    label: 'Total',
                    value: formatRupiah(transaction.totalAmount),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GlobalsCard(
              hasShadow: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expert',
                    style: AppTextStyles.heading3SemiBold(AppColors.base1),
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Role',
                    value: transaction.expert?.displayRole ?? '-',
                  ),
                  _DetailRow(
                    label: 'Spesialisasi',
                    value: transaction.expert?.specialization ?? '-',
                  ),
                  _DetailRow(label: 'Hari Praktik', value: _workingDays),
                  _DetailRow(label: 'Jam Praktik', value: _workingHours),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlobalsButton(
              text: ConsultationTicketSessionLauncher.actionLabel(transaction),
              onPressed: canJoin
                  ? () => ConsultationTicketSessionLauncher.openSession(
                      context,
                      transaction,
                    )
                  : null,
              color: canJoin ? AppColors.primary1 : AppColors.base3,
              textColor: canJoin ? AppColors.base5 : AppColors.base2,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final resolvedValue = value.trim().isEmpty ? '-' : value.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.list1Regular(AppColors.base2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              resolvedValue,
              style: AppTextStyles.list1Bold(AppColors.base1),
            ),
          ),
        ],
      ),
    );
  }
}
