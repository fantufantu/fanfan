import 'package:fanfan/service/factories/entity.dart';

class FilterBy extends Entity {
  // 账本id
  int billingId;

  // 分类id
  List<int>? categoryIds;

  FilterBy({
    required this.billingId,
    this.categoryIds,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "billingId": billingId,
      "categoryIds": categoryIds,
    };
  }
}
