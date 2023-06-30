import 'package:fanfan/service/factories/entity.dart';

class GroupBy extends Entity {
  // 账本id
  int billingId;

  // 起始时间
  DateTime? happenedFrom;

  // 截止时间
  DateTime? happenedTo;

  //

  GroupBy({
    required this.billingId,
    this.happenedFrom,
    this.happenedTo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "billingId": billingId,
      // "happenedFrom": happenedFrom?.toString(),
      // "happenedTo": happenedTo?.toString(),
    };
  }
}
