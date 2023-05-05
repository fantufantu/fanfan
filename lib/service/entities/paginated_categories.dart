import 'package:fanfan/service/entities/category.dart';

class PaginatedCategories {
  PaginatedCategories({
    required this.total,
    required this.items,
  });

  int total;
  List<Category> items;

  factory PaginatedCategories.fromJson(Map<String, dynamic> json) =>
      PaginatedCategories(
        total: json["total"],
        items: (json["items"] as List<Map<String, dynamic>>)
            .map((item) => Category.fromJson(item))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "items": items.map((billing) => billing.toJson()).toList(),
      };
}
