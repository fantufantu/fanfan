import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fanfan/service/user.dart';

class UserProfile with ChangeNotifier, DiagnosticableTreeMixin {
  /// 是否已登录
  bool _isLoggedIn = false;

  /// 用户信息
  WhoAmI? _whoAmI = null;

  /// token
  String _token = '';

  /// 请求客户端
  GraphQLClient _client;

  /// 构造函数
  UserProfile(this._client);

  /// get token
  String? get token {
    return _token;
  }

  /// get whoAmI
  get whoAmI {
    return _whoAmI;
  }

  /// isLoggedIn
  get isLoggedIn {
    return _isLoggedIn;
  }

  /// 交换用户信息
  authorize() async {
    final fetched =
        await _client.query<WhoAmI>(QueryOptions(document: WHO_AM_I));

    if (fetched.hasException || fetched.parsedData == null) {
      _isLoggedIn = false;
      _whoAmI = null;
      _token = '';
      return;
    }

    _isLoggedIn = true;
    _whoAmI = fetched.parsedData;
  }
}
