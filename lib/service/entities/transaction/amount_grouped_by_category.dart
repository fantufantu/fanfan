class AmountGroupedByCategory {
  // 分类id
  final int? categoryId;

  // 合计
  final double? amount;

  AmountGroupedByCategory({
    this.categoryId,
    this.amount,
  });

  factory AmountGroupedByCategory.fromJson(Map<String, dynamic> json) =>
      AmountGroupedByCategory(
        categoryId: json["categoryId"],
        amount: double.tryParse(json['amount'].toString()),
      );
}
