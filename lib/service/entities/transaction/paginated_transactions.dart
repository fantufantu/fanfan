import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/factories/paginated.dart';

class PaginatedTransactions extends Paginated<Transaction> {
  PaginatedTransactions({
    required super.total,
    required super.items,
  });

  factory PaginatedTransactions.fromJson(Map<String, dynamic> json) =>
      PaginatedTransactions(
        total: json["total"],
        items: (json["items"] as List<dynamic>)
            .map((item) => Transaction.fromJson(item))
            .toList(),
      );
}
