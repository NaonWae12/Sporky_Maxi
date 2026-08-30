import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';
import 'package:sporky_maxi/models/api/paginated_state.dart';
import 'package:sporky_maxi/models/components/payment/point_model.dart';
import 'package:sporky_maxi/models/components/payment/transaction_model.dart';

import 'cmp_list_transactions_history.dart';

enum TransactionHistoryFilter { all, product, point }

class TransactionHistoryList extends StatefulWidget {
  final TransactionHistoryFilter filter;

  const TransactionHistoryList({super.key, required this.filter});

  @override
  State<TransactionHistoryList> createState() => _TransactionHistoryListState();
}

class _TransactionHistoryListState extends State<TransactionHistoryList> {
  static const ApiFoundationService _service = ApiFoundationService();
  static const int _perPage = 20;

  final ScrollController _scrollController = ScrollController();
  PaginatedState<_HistoryItem> _state = const PaginatedState(
    items: [],
    currentPage: 0,
    lastPage: 1,
  );
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter > 240) return;
    if (!_state.hasMore || _state.isLoadingMore) return;
    _loadMore();
  }

  Future<({List<_HistoryItem> items, int currentPage, int lastPage})>
  _fetchPage(int page) async {
    if (widget.filter == TransactionHistoryFilter.point) {
      final response = await _service.getPointHistory(
        page: page,
        perPage: _perPage,
      );
      return (
        items: response.histories.map(_mapPointHistory).toList(),
        currentPage: response.currentPage,
        lastPage: response.lastPage,
      );
    }

    final response = await _service.getTransactions(
      page: page,
      perPage: _perPage,
    );
    final transactions = widget.filter == TransactionHistoryFilter.product
        ? response.transactions.where((item) => item.product != null)
        : response.transactions;

    return (
      items: transactions.map(_mapTransaction).toList(),
      currentPage: response.pagination.currentPage,
      lastPage: response.pagination.lastPage,
    );
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      final page = await _fetchPage(1);
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: page.items,
          currentPage: page.currentPage,
          lastPage: page.lastPage,
        );
        _isInitialLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(error: error);
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _state = _state.copyWith(isLoadingMore: true);
    });

    try {
      final page = await _fetchPage(_state.currentPage + 1);
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: [..._state.items, ...page.items],
          currentPage: page.currentPage,
          lastPage: page.lastPage,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(isLoadingMore: false);
      });
    }
  }

  Future<void> _refreshHistory() async {
    await _loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_state.error != null) {
      return _RefreshableHistoryState(
        onRefresh: _refreshHistory,
        child: TextButton(
          onPressed: _loadInitial,
          child: const Text('Gagal memuat riwayat. Coba lagi'),
        ),
      );
    }

    final items = _state.items;
    if (items.isEmpty) {
      return _RefreshableHistoryState(
        onRefresh: _refreshHistory,
        child: Text(
          'Belum ada riwayat',
          style: AppTextStyles.list1Regular(AppColors.base2),
        ),
      );
    }

    final grouped = _groupByDate(items);

    return RefreshIndicator(
      onRefresh: _refreshHistory,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: grouped.keys.length + (_state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= grouped.keys.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final key = grouped.keys.elementAt(index);
          final entryItems = grouped[key]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(key, style: AppTextStyles.heading2SemiBold()),
              const SizedBox(height: 8),
              for (final item in entryItems) ...[
                CmpListTransactionsHistory(
                  iconAsset: item.iconAsset,
                  iconColor: item.iconColor,
                  title: item.title,
                  price: item.amount,
                  amountLabel: item.amountLabel,
                  desc: item.description,
                  timeStamp: item.timeStamp,
                  transactionType: item.transactionType,
                ),
                const Divider(),
              ],
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  _HistoryItem _mapTransaction(AppTransaction transaction) {
    final product = transaction.product;
    final title = product?.name.isNotEmpty == true
        ? product!.name
        : _transactionTitle(transaction.status);
    final status = _statusLabel(transaction.status);
    final paymentMethod = transaction.paymentMethod.trim();
    final dateTime = transaction.date ?? transaction.createdAt;

    return _HistoryItem(
      iconAsset: _transactionIcon(product?.type),
      title: title,
      amount: transaction.totalAmount,
      description: paymentMethod.isEmpty
          ? status
          : '$status via $paymentMethod',
      timeStamp: _formatDateTime(dateTime),
      transactionType: 'out',
      dateTime: dateTime,
    );
  }

  _HistoryItem _mapPointHistory(PointHistoryItem history) {
    final isEarned = history.points >= 0;
    final title =
        history.taskTitle ?? history.productName ?? _pointTitle(history.type);
    final description = history.description.isEmpty
        ? _pointTitle(history.type)
        : history.description;

    return _HistoryItem(
      iconAsset: 'assets/svg/ic_coin.svg',
      iconColor: AppColors.secondary1,
      title: title,
      amount: history.points.abs().toDouble(),
      amountLabel: '${isEarned ? '+' : '-'}${history.points.abs()} Koin',
      description: description,
      timeStamp: _formatDateTime(history.createdAt),
      transactionType: isEarned ? 'in' : 'out',
      dateTime: history.createdAt,
    );
  }

  Map<String, List<_HistoryItem>> _groupByDate(List<_HistoryItem> items) {
    final grouped = <String, List<_HistoryItem>>{};
    for (final item in items) {
      grouped
          .putIfAbsent(_dateLabel(item.dateTime), () => <_HistoryItem>[])
          .add(item);
    }
    return grouped;
  }

  String _dateLabel(DateTime? dateTime) {
    if (dateTime == null) return 'Lainnya';

    final localDate = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(localDate.year, localDate.month, localDate.day);

    if (date == today) return 'Hari Ini';
    if (date == yesterday) return 'Kemarin';
    return DateFormat('d MMMM yyyy', 'id_ID').format(localDate);
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('dd/MM/yyyy HH.mm').format(dateTime.toLocal());
  }

  String _transactionTitle(String status) {
    return 'Transaksi ${_statusLabel(status)}';
  }

  String _statusLabel(String status) {
    return switch (status.toLowerCase()) {
      'pending' => 'Menunggu pembayaran',
      'completed' => 'Berhasil',
      'failed' => 'Gagal',
      'cancelled' || 'canceled' => 'Dibatalkan',
      _ => status.isEmpty ? 'Transaksi' : status,
    };
  }

  String _pointTitle(String type) {
    return switch (type.toLowerCase()) {
      'task_reward' => 'Reward Daily Task',
      'milestone_bonus' => 'Bonus Milestone',
      'purchase' => 'Pembelian dengan Koin',
      'redeem' => 'Penukaran Koin',
      'refund' => 'Refund Koin',
      'adjustment' => 'Penyesuaian Koin',
      _ => 'Riwayat Koin',
    };
  }

  String _transactionIcon(String? productType) {
    return switch (productType?.toLowerCase()) {
      'consultation' || 'chat' || 'zoom' => 'assets/svg/user-doctor.svg',
      'voucher' => 'assets/svg/ic_coupon - ticket.svg',
      _ => 'assets/svg/Crown-1.svg',
    };
  }
}

class _HistoryItem {
  final String iconAsset;
  final Color? iconColor;
  final String title;
  final double amount;
  final String? amountLabel;
  final String description;
  final String timeStamp;
  final String transactionType;
  final DateTime? dateTime;

  const _HistoryItem({
    required this.iconAsset,
    this.iconColor,
    required this.title,
    required this.amount,
    this.amountLabel,
    required this.description,
    required this.timeStamp,
    required this.transactionType,
    required this.dateTime,
  });
}

class _RefreshableHistoryState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const _RefreshableHistoryState({
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
