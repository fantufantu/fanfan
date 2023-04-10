import 'package:fanfan/service/main.dart';
import 'package:flutter/foundation.dart';
import 'package:fanfan/service/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserProfile with ChangeNotifier, DiagnosticableTreeMixin {
  static final UserProfile _instance = UserProfile._internal();
  late Service _service;
  String _token = '';
  WhoAmI? _whoAmI = null;
  bool _isLoggedIn = false;

  UserProfile._internal() {
    _service = Service();
  }

  factory UserProfile() => _instance;

  String get token {
    return _token;
  }

  WhoAmI? get whoAmI {
    return _whoAmI;
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  /// 交换用户信息
  authorize() async {
    final fetched =
        await _service.client.query<WhoAmI>(QueryOptions(document: WHO_AM_I));

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
