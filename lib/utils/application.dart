import 'package:fanfan/service/entities/paginated_categories.dart';
import 'package:fanfan/service/entities/who_am_i.dart';
import 'package:fanfan/service/schemas/application.dart';
import 'package:fanfan/utils/service.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanfan/store/user_profile.dart' as store show UserProfile;
import 'package:fanfan/store/category.dart' as store show Category;

enum StorageToken {
  token,
}

Future<void> initialize() async {
  // 获取持久化缓存的实例
  final SharedPreferences storage = await SharedPreferences.getInstance();
  // 获取持久化存储的token
  final token = storage.getString(describeEnum(StorageToken.token)) ?? '';

  // 用户信息
  final userProfile = store.UserProfile()..setToken(token);
  // 分类
  final category = store.Category();

  final response = await Client().query(QueryOptions(
    document: INITIALIZE,
    fetchPolicy: FetchPolicy.noCache,
  ));

  // 归属用户信息
  if (response.data?['whoAmI'] != null) {
    userProfile.belong(WhoAmI.fromJson(response.data!['whoAmI']));
  }
  // 归属分类
  if (response.data?['categories'] != null) {
    print(response.data!['categories']);
    category.belong(
        PaginatedCategories.fromJson(response.data!['categories']).items);
  }
}

Future<void> reinitialize(String? token) async {
  if ((token ?? '').isEmpty) return;

  // 获取持久化缓存的实例
  final SharedPreferences storage = await SharedPreferences.getInstance();
  // 存储 token
  storage.setString(describeEnum(StorageToken.token), token!);

  final userProfile = store.UserProfile();
  // 设置token
  userProfile.setToken(token);
  // 换用户信息
  userProfile.authorize();
}
