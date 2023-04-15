import 'package:fanfan/service/main.dart';
import 'package:flutter/foundation.dart';
import 'package:fanfan/service/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserProfile with ChangeNotifier, DiagnosticableTreeMixin {
  /// 单例
  static UserProfile? _instance;

  /// 请求客户端
  late Client _client;

  /// 用户凭证
  String _token = '';

  /// 用户信息
  WhoAmI? _whoAmI;

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

  /// 交换用户信息
  authorize() async {
    final authorized =
        await _client.query<WhoAmI>(QueryOptions(document: WHO_AM_I));

    if (authorized.hasException || authorized.parsedData == null) {
      _whoAmI = null;
      _token = '';
      return;
    }

    _whoAmI = authorized.parsedData;
  }

  get clent {
    return _client;
  }
}
