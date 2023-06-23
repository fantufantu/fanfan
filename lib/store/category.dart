import 'package:flutter/foundation.dart';
import 'package:fanfan/service/entities/category.dart' as entities;

class Category with ChangeNotifier, DiagnosticableTreeMixin {
  /// 单例
  static Category? _instance;

  Category._internal();

  factory Category() => _instance ??= Category._internal();

  /// 分类列表
  List<entities.Category> _categories = [];

  belong(List<entities.Category> categories) {
    _categories = categories;

    // 消息触达
    notifyListeners();
  }

  List<entities.Category> get categories {
    return _categories;
  }
}
