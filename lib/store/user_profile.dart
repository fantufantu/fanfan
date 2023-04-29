import 'package:fanfan/service/entities/billing.dart';
import 'package:fanfan/utils/service.dart';
import 'package:flutter/foundation.dart';
import 'package:fanfan/service/schemas/user.dart';
import 'package:fanfan/service/entities/who_am_i.dart';
import 'package:graphql/client.dart';
import 'package:uuid/uuid.dart';

class UserProfile with ChangeNotifier, DiagnosticableTreeMixin {
  /// 单例
  static UserProfile? _instance;

  /// 请求客户端
  late Client _client;

  /// 用户凭证
  String _token = '';

  /// 用户信息
  WhoAmI? _whoAmI;

  final _count = 0;

  UserProfile._internal() {
    _client = Client();
  }

  factory UserProfile() => _instance ??= UserProfile._internal();

  String get token {
    return _token;
  }

  WhoAmI? get whoAmI {
    return _whoAmI;
  }

  bool get isLoggedIn {
    return _whoAmI != null;
  }

  int get count {
    return _count;
  }

  /// 交换用户信息
  authorize() async {
    final response =
        await _client.query<WhoAmI>(QueryOptions(document: WHO_AM_I));

    if (response.hasException || response.data == null) {
      _whoAmI = null;
      _token = '';
    } else {
      _whoAmI = WhoAmI.fromJson(response.data!['whoAmI']);
    }

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
    final response = await _client.query<WhoAmI>(QueryOptions(
      document: DEFAULT_BILLING,
      fetchPolicy: FetchPolicy.noCache,
    ));

    final defaultBilling = response.data?['whoAmI']['defaultBilling'];

    _whoAmI!.defaultBilling =
        defaultBilling != null ? Billing.fromJson(defaultBilling) : null;

    // 消息触达
    notifyListeners();
  }
}
