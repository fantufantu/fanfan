import 'package:fanfan/service/factories/entity.dart';

class FilterBy extends Entity {
  // 账本id
  int billingId;

  // 分类id
  List<int>? categoryIds;

  // 起始时间
  DateTime? happenedFrom;

  // 截止时间
  DateTime? happenedTo;

  FilterBy({
    required this.billingId,
    this.categoryIds,
    this.happenedFrom,
    this.happenedTo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "billingId": billingId,
      "categoryIds": categoryIds,
      "happenedFrom": happenedFrom?.toString(),
      "happenedTo": happenedTo?.toString(),
    };
  }
}
