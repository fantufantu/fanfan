import 'package:fanfan/service/factories/entity.dart';
import 'package:fanfan/service/entities/billing/main.dart' show Billing;

class Editable extends Entity {
  Editable({
    this.billing,
    this.categoryId,
    this.amount,
    this.happenedAt,
    this.remark,
  });

  /// 交易归属的账本
  Billing? billing;

  /// 交易所属分类id
  int? categoryId;

  /// 交易金额
  double? amount;

  /// 交易发生时间
  DateTime? happenedAt;

  /// 交易备注
  String? remark;

  @override
  Map<String, dynamic> toJson() => {
        "billingId": billing?.id,
        "categoryId": categoryId,
        "amount": amount,
        "happenedAt": happenedAt?.toString(),
        "remark": remark
      };
}
