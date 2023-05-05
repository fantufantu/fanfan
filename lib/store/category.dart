import 'package:fanfan/service/api/category.dart';
import 'package:flutter/foundation.dart';
import 'package:fanfan/service/entities/category.dart' as entities;

class Category with ChangeNotifier, DiagnosticableTreeMixin {
  List<entities.Category> categories = [];

  Category() {
    intiialize();
  }

  /// 初始化获取分类
  void intiialize() async {
    categories = (await queryCategories()).items;
    notifyListeners();
  }
}
