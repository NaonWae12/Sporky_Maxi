import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/card/card_agenda_cmp.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/foundation/api_foundation_service.dart';
import 'package:sporky_maxi/models/api/paginated_state.dart';
import 'package:sporky_maxi/models/components/consultation/expert_agenda_model.dart';

class ExpertAgendaList extends StatefulWidget {
  final String? type;
  final int limit;
  final bool showHeader;
  final bool useOwnScroll;

  const ExpertAgendaList({
    super.key,
    this.type,
    this.limit = 3,
    this.showHeader = false,
    this.useOwnScroll = false,
  });

  @override
  State<ExpertAgendaList> createState() => _ExpertAgendaListState();
}

class _ExpertAgendaListState extends State<ExpertAgendaList> {
  static const ApiFoundationService _service = ApiFoundationService();
  static const int _perPage = 20;

  final ScrollController _scrollController = ScrollController();
  PaginatedState<ExpertAgenda> _state = const PaginatedState(
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
      final response = await _service.getExpertAgenda(
        type: widget.type,
        page: 1,
        perPage: _perPage,
      );
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: response.consultations,
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
    setState(() {
      _state = _state.copyWith(isLoadingMore: true);
    });

    try {
      final response = await _service.getExpertAgenda(
        type: widget.type,
        page: _state.currentPage + 1,
        perPage: _perPage,
      );
      if (!mounted) return;
      setState(() {
        _state = PaginatedState(
          items: [..._state.items, ...response.consultations],
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

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_state.error != null) {
      return SizedBox(
        height: 160,
        child: Center(
          child: TextButton(
            onPressed: _loadInitial,
            child: const Text('Gagal memuat agenda. Coba lagi'),
          ),
        ),
      );
    }

    if (_state.items.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('Belum ada agenda konsultasi')),
      );
    }

    final consultations = _state.items.take(widget.limit).toList();

    final content = Column(
      children: [
        if (widget.showHeader)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Agenda Konsultasi',
                style: AppTextStyles.heading3SemiBold(),
              ),
            ),
          ),
        ...consultations.map((agenda) {
          final isZoom = agenda.type.toLowerCase() == 'zoom';

          return CardAgendaCmp(
            nameChild: agenda.user?.name ?? 'Pasien',
            nameParrent: agenda.user?.name ?? 'Orangtua',
            chat: isZoom
                ? 'Konsultasi Zoom ${agenda.product?.duration ?? '-'} menit'
                : 'Konsultasi chat ${agenda.product?.duration ?? '-'} menit',
            category: isZoom ? AgendaCategory.video : AgendaCategory.chat,
            isOnline: agenda.zoomLink?.isNotEmpty == true,
            isScheduled: agenda.zoomLink?.isNotEmpty != true,
          );
        }),
        if (_state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );

    if (!widget.useOwnScroll) {
      return SingleChildScrollView(
        controller: _scrollController,
        child: content,
      );
    }

    return content;
  }
}
