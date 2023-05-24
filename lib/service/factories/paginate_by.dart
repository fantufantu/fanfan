class PaginateBy {
  PaginateBy({
    required this.page,
    required this.pageSize,
  });

  /// 页码
  int page;

  /// 页大小
  int pageSize;

  Map<String, int> toJson() => {
        "page": page,
        "pageSize": pageSize,
      };
}
