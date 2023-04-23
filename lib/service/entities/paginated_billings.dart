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
        items: List<Billing>.from(
          json["instructions"].map(
            (item) => Billing.fromJson(item),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "items": List<dynamic>.from(items.map((billing) => billing.toJson())),
      };
}
