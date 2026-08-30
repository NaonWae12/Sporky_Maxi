import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/consultation_cmp/ticket_consultation_cmp/consultation_ticket_card.dart';
import 'package:sporky_maxi/components/consultation_cmp/ticket_consultation_cmp/consultation_ticket_status.dart';
import 'package:sporky_maxi/components/globals/card/cmp_tag_attention.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';
import 'package:sporky_maxi/core/utils/consultation_ticket_session_launcher.dart';
import 'package:sporky_maxi/models/components/payment/transaction_model.dart';

import '../../../components/globals/bar/full_width_tab_bar.dart';
import '../../../components/globals/text/text_style.dart';
import 'page_detail_ticket_cst.dart';

class MainPageTicketCst extends StatefulWidget {
  const MainPageTicketCst({super.key});

  @override
  State<MainPageTicketCst> createState() => _MainPageTicketCstState();
}

class _MainPageTicketCstState extends State<MainPageTicketCst> {
  static const ApiFoundationService _foundationService = ApiFoundationService();

  late Future<_TicketBuckets> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _fetchTickets();
  }

  Future<_TicketBuckets> _fetchTickets() async {
    final responses = await Future.wait([
      _foundationService.getTransactions(status: 'pending', perPage: 100),
      _foundationService.getTransactions(status: 'completed', perPage: 100),
    ]);

    final transactions = responses
        .expand((response) => response.transactions)
        .where((transaction) => transaction.isConsultation)
        .toList();

    return _TicketBuckets.fromTransactions(transactions);
  }

  Future<void> _refreshTickets() async {
    setState(() {
      _ticketsFuture = _fetchTickets();
    });

    await _ticketsFuture;
  }

  void _openDetail(
    AppTransaction transaction,
    ConsultationTicketStatus status,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PageDetailTicketCst(transaction: transaction, ticketStatus: status),
      ),
    );
  }

  Future<void> _handlePrimaryAction(
    AppTransaction transaction,
    ConsultationTicketStatus status,
  ) async {
    if (!ConsultationTicketSessionLauncher.canOpenSession(transaction)) {
      _openDetail(transaction, status);
      return;
    }

    await ConsultationTicketSessionLauncher.openSession(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text('Tiket Konsultasi', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: Column(
        children: [
          const CmpTagAttention(
            text:
                'Bunda bisa mulai konsultasi sekarang jika expert tersedia, atau atur jadwal di waktu yang paling nyaman. Jangan khawatir, tiket berlaku selama 30 hari setelah pembelian.',
            imageAsset: 'assets/svg/ic_warn.svg',
            imageColor: AppColors.info1,
            lineColor: AppColors.info1,
            space: 10,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<_TicketBuckets>(
              future: _ticketsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: TextButton(
                      onPressed: _refreshTickets,
                      child: const Text('Gagal memuat tiket. Coba lagi'),
                    ),
                  );
                }

                final buckets = snapshot.data ?? const _TicketBuckets.empty();

                return FullWidthTabBar(
                  tabs: ConsultationTicketStatus.values
                      .map((status) => status.title)
                      .toList(),
                  tabViews: [
                    _TicketList(
                      status: ConsultationTicketStatus.notYet,
                      transactions: buckets.notYet,
                      onRefresh: _refreshTickets,
                      onOpenDetail: _openDetail,
                      onPrimaryAction: _handlePrimaryAction,
                    ),
                    _TicketList(
                      status: ConsultationTicketStatus.schedule,
                      transactions: buckets.schedule,
                      onRefresh: _refreshTickets,
                      onOpenDetail: _openDetail,
                      onPrimaryAction: _handlePrimaryAction,
                    ),
                    _TicketList(
                      status: ConsultationTicketStatus.finish,
                      transactions: buckets.finish,
                      onRefresh: _refreshTickets,
                      onOpenDetail: _openDetail,
                      onPrimaryAction: _handlePrimaryAction,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final ConsultationTicketStatus status;
  final List<AppTransaction> transactions;
  final Future<void> Function() onRefresh;
  final void Function(
    AppTransaction transaction,
    ConsultationTicketStatus status,
  )
  onOpenDetail;
  final Future<void> Function(
    AppTransaction transaction,
    ConsultationTicketStatus status,
  )
  onPrimaryAction;

  const _TicketList({
    required this.status,
    required this.transactions,
    required this.onRefresh,
    required this.onOpenDetail,
    required this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: transactions.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      status.emptyMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.list1Regular(AppColors.base2),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ConsultationTicketCard(
                  transaction: transaction,
                  ticketStatus: status,
                  onTap: () => onOpenDetail(transaction, status),
                  onPrimaryAction: () => onPrimaryAction(transaction, status),
                );
              },
            ),
    );
  }
}

class _TicketBuckets {
  final List<AppTransaction> notYet;
  final List<AppTransaction> schedule;
  final List<AppTransaction> finish;

  const _TicketBuckets({
    required this.notYet,
    required this.schedule,
    required this.finish,
  });

  const _TicketBuckets.empty()
    : notYet = const <AppTransaction>[],
      schedule = const <AppTransaction>[],
      finish = const <AppTransaction>[];

  factory _TicketBuckets.fromTransactions(List<AppTransaction> transactions) {
    final notYet = <AppTransaction>[];
    final schedule = <AppTransaction>[];
    final finish = <AppTransaction>[];
    for (final transaction in transactions) {
      if (transaction.isPending) {
        notYet.add(transaction);
      } else if (_isFinished(transaction)) {
        finish.add(transaction);
      } else {
        schedule.add(transaction);
      }
    }

    notYet.sort(_compareNewestFirst);
    schedule.sort(_compareScheduleFirst);
    finish.sort(_compareNewestFirst);

    return _TicketBuckets(notYet: notYet, schedule: schedule, finish: finish);
  }

  static bool _isFinished(AppTransaction transaction) {
    final consultationStatus =
        transaction.consultation?.status.toLowerCase().trim() ?? '';
    return consultationStatus == 'completed' ||
        consultationStatus == 'cancelled';
  }

  static int _compareNewestFirst(AppTransaction a, AppTransaction b) {
    final aDate = a.createdAt ?? a.date ?? a.consultationDate;
    final bDate = b.createdAt ?? b.date ?? b.consultationDate;
    return _millis(bDate).compareTo(_millis(aDate));
  }

  static int _compareScheduleFirst(AppTransaction a, AppTransaction b) {
    final aDate = a.consultationDate ?? a.createdAt ?? a.date;
    final bDate = b.consultationDate ?? b.createdAt ?? b.date;
    return _millis(aDate).compareTo(_millis(bDate));
  }

  static int _millis(DateTime? value) {
    return value?.millisecondsSinceEpoch ?? 0;
  }
}
