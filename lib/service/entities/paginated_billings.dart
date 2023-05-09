import 'package:fanfan/service/entities/billing.dart';
import 'package:fanfan/service/factories/paginated.dart';

class PaginatedBillings extends Paginated<Billing> {
  PaginatedBillings({
    required super.total,
    required super.items,
  });

  factory PaginatedBillings.fromJson(Map<String, dynamic> json) =>
      PaginatedBillings(
        total: json["total"],
        items: (json["items"] as List<dynamic>)
            .map((item) => Billing.fromJson(item))
            .toList(),
      );
}
