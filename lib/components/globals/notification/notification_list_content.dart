import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporky_maxi/components/globals/card/card_notification_cmp.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';
import 'package:sporky_maxi/models/api/paginated_state.dart';
import 'package:sporky_maxi/models/components/notification/app_notification_model.dart';

class NotificationListContent extends StatefulWidget {
  const NotificationListContent({super.key});

  @override
  State<NotificationListContent> createState() =>
      _NotificationListContentState();
}

class _NotificationListContentState extends State<NotificationListContent> {
  static const ApiFoundationService _service = ApiFoundationService();
  static const int _perPage = 20;

  final ScrollController _scrollController = ScrollController();

  PaginatedState<AppNotification> _state = const PaginatedState(
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

  Future<void> _loadInitial() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      final response = await _service.getNotifications(
        page: 1,
        perPage: _perPage,
      );
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: response.notifications,
          currentPage: response.pagination.currentPage,
          lastPage: response.pagination.lastPage,
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
    final nextPage = _state.currentPage + 1;
    setState(() {
      _state = _state.copyWith(isLoadingMore: true);
    });

    try {
      final response = await _service.getNotifications(
        page: nextPage,
        perPage: _perPage,
      );
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: [..._state.items, ...response.notifications],
          currentPage: response.pagination.currentPage,
          lastPage: response.pagination.lastPage,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(isLoadingMore: false);
      });
    }
  }

  Future<void> _refresh() async {
    await _loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_state.error != null) {
      return _RefreshableState(
        onRefresh: _refresh,
        child: TextButton(
          onPressed: _loadInitial,
          child: const Text('Gagal memuat notifikasi. Coba lagi'),
        ),
      );
    }

    if (_state.items.isEmpty) {
      return _RefreshableState(
        onRefresh: _refresh,
        child: Text(
          'Belum ada notifikasi',
          style: AppTextStyles.list1Regular(AppColors.base2),
        ),
      );
    }

    final grouped = _groupByDate(_state.items);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: grouped.keys.length + (_state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= grouped.keys.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final key = grouped.keys.elementAt(index);
          final notifications = grouped[key]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 10),
                child: Text(key, style: AppTextStyles.heading3SemiBold()),
              ),
              ...notifications.map(_buildNotificationCard),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return CardNotificationCmp(
      title: notification.title.isEmpty
          ? 'Notifikasi Sporky'
          : notification.title,
      desc: _descriptionFor(notification.type),
      category: notification.type,
      iconColor: notification.isRead ? AppColors.base1 : AppColors.warn1,
      timeLabel: _formatTime(notification.createdAt),
      isRead: notification.isRead,
    );
  }

  Map<String, List<AppNotification>> _groupByDate(
    List<AppNotification> notifications,
  ) {
    final grouped = <String, List<AppNotification>>{};
    for (final notification in notifications) {
      final label = _dateLabel(notification.createdAt);
      grouped.putIfAbsent(label, () => <AppNotification>[]).add(notification);
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

    if (date == today) return 'Hari ini';
    if (date == yesterday) return 'Kemarin';
    return DateFormat('d MMMM yyyy', 'id_ID').format(localDate);
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return '${DateFormat('HH.mm').format(dateTime.toLocal())} WIB';
  }

  String _descriptionFor(String type) {
    return switch (type.toLowerCase()) {
      'consultation' ||
      'consultations' => 'Ada pembaruan konsultasi untuk Bunda.',
      'chat' => 'Ada pesan chat terbaru untuk Bunda.',
      'video' => 'Ada video edukasi baru yang bisa ditonton.',
      'promo' => 'Ada promo terbaru dari Sporky & Maxi.',
      'order' => 'Ada pembaruan pesanan atau transaksi.',
      _ => 'Ada pembaruan terbaru dari Sporky & Maxi.',
    };
  }
}

class _RefreshableState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const _RefreshableState({required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
