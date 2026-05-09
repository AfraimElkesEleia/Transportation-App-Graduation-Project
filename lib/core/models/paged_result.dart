class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const PagedResult({
    required this.items,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  bool get hasMore => currentPage < totalPages;
  bool get isEmpty => items.isEmpty;
}
