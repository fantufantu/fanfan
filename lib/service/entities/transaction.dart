import 'package:fanfan/service/factories/entity.dart';

enum Direction {
  Out,
  In,
}

class Transaction extends Entity {
  Transaction({
    this.id,
    this.billingId,
    this.categoryId,
    this.direction,
    this.amount,
    this.happenedAt,
    this.remark,
  });

  /// 交易id
  int? id;

  /// 交易归属的账本id
  int? billingId;

  /// 交易所属分类id
  int? categoryId;

  /// 交易方向
  Direction? direction;

  /// 交易金额
  double? amount;

  /// 交易发生时间
  DateTime? happenedAt;

  /// 交易备注
  String? remark;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "billingId": billingId,
        "categoryId": categoryId,
        "direction": direction?.name,
        "amount": amount,
        "happenedAt": happenedAt?.toString(),
        "remark": remark
      };

  factory Transaction.initialize() => Transaction(
        direction: Direction.Out,
        happenedAt: DateTime.now(),
        amount: 0,
        remark: "",
      );
}
