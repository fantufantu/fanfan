class PaginateBy {
  PaginateBy({
    required this.page,
    required this.limit,
  });

  /// 页码
  int page;

  /// 页大小
  int limit;

  Map<String, int> toJson() => {
        "page": page,
        "limit": limit,
      };
}
