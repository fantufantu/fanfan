import 'package:fanfan/service/entities/billing.dart';

class PaginatedBillings {
  PaginatedBillings({
    required this.total,
    required this.items,
  });

  int total;
  List<Billing> items;

  factory PaginatedBillings.fromJson(Map<String, dynamic> json) =>
      PaginatedBillings(
        total: json["total"],
        items: (json["items"] as List<dynamic>)
            .map(
              (item) => Billing.fromJson(item),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "items": items.map((billing) => billing.toJson()).toList(),
      };
}
