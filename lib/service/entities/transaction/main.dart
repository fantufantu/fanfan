import 'package:fanfan/service/factories/entity.dart';
import 'package:fanfan/service/entities/category.dart';

class Transaction extends Entity {
  Transaction({
    this.id,
    this.billingId,
    this.categoryId,
    this.amount,
    this.happenedAt,
    this.remark,
    this.category,
  });

  /// 交易id
  int? id;

  /// 交易归属的账本id
  int? billingId;

  /// 交易所属分类id
  int? categoryId;

  /// 交易金额
  double? amount;

  /// 交易发生时间
  DateTime? happenedAt;

  /// 交易备注
  String? remark;

  /// 交易分类
  Category? category;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        billingId: json['billingId'],
        categoryId: json['categoryId'],
        amount: double.tryParse(json['amount'].toString()),
        happenedAt: json['happenedAt'] != null
            ? DateTime.tryParse(json['happenedAt'])?.toLocal()
            : null,
        remark: json['remark'],
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "billingId": billingId,
        "categoryId": categoryId,
        "amount": amount,
        "happenedAt": happenedAt?.toString(),
        "remark": remark,
        "category": category?.toJson(),
      };
}
