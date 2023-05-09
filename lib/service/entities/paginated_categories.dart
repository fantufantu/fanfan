import 'package:fanfan/service/entities/category.dart';
import 'package:fanfan/service/factories/paginated.dart';

class PaginatedCategories extends Paginated<Category> {
  PaginatedCategories({
    super.total,
    required super.items,
  });

  factory PaginatedCategories.fromJson(Map<String, dynamic> json) =>
      PaginatedCategories(
        total: json["total"],
        items: (json["items"] as List<dynamic>)
            .map((item) => Category.fromJson(item))
            .toList(),
      );
}
