class PaginatedState<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final bool isLoadingMore;
  final Object? error;

  const PaginatedState({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => currentPage < lastPage;

  PaginatedState<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? lastPage,
    bool? isLoadingMore,
    Object? error,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }
}
