import 'package:fanfan/service/entities/billing/main.dart';
import 'package:fanfan/service/entities/user/editable.dart';
import 'package:fanfan/utils/application.dart';
import 'package:fanfan/utils/service.dart';
import 'package:flutter/foundation.dart';
import 'package:fanfan/service/schemas/user.dart';
import 'package:fanfan/service/entities/user.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile with ChangeNotifier, DiagnosticableTreeMixin {
  /// 单例
  static UserProfile? _instance;

  /// 请求客户端
  late Client _client;

  /// 用户凭证
  String _token = '';

  /// 用户信息
  User? _whoAmI;

  UserProfile._internal() {
    _client = Client();
  }

  factory UserProfile() => _instance ??= UserProfile._internal();

  String get token {
    return _token;
  }

  User? get whoAmI {
    return _whoAmI;
  }

  bool get isLoggedIn {
    return _whoAmI != null;
  }

  /// 交换用户信息
  authorize() async {
    final response = await _client.query<User>(QueryOptions(
      document: WHO_AM_I,
      fetchPolicy: FetchPolicy.noCache,
    ));

    if (response.hasException || response.data == null) {
      _whoAmI = null;
      _token = '';
    } else {
      _whoAmI = User.fromJson(response.data!['whoAmI']);
    }

    // 消息触达
    notifyListeners();
  }

  /// 归属用户信息
  void belong(User? whoAmI) {
    _whoAmI = whoAmI;

    // 消息触达
    notifyListeners();
  }

  /// 设置 token
  setToken(String token) {
    _token = token;

    // 消息触达
    notifyListeners();
  }

  /// 刷新默认账本信息
  refreshDefaultBilling() async {
    final response = await _client.query<User>(QueryOptions(
      document: DEFAULT_BILLING,
      fetchPolicy: FetchPolicy.noCache,
    ));

    final defaultBilling = response.data?['whoAmI']['defaultBilling'];

    _whoAmI!.defaultBilling =
        defaultBilling != null ? Billing.fromJson(defaultBilling) : null;

    // 消息触达
    notifyListeners();
  }

  /// 登出
  Future<bool> logout() async {
    // 获取持久化缓存的实例
    final SharedPreferences storage = await SharedPreferences.getInstance();
    final isRemoved = await storage.remove(describeEnum(StorageToken.token));

    if (!isRemoved) return false;
    _whoAmI = null;
    _token = "";

    // 消息触达
    notifyListeners();

    return true;
  }

  /// 更新用户信息
  update(Editable updateBy) {
    whoAmI?.nickname = updateBy.nickname;

    // 消息触达
    notifyListeners();
  }
}
