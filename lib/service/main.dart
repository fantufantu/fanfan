import 'package:fanfan/store/user_profile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Client {
  /// 客户端
  late GraphQLClient _client;

  /// 用户 store
  late UserProfile _userProfile;

  // 实例化
  Client() {
    final HttpLink httpLink = HttpLink(
      'https://api.fantufantu.com/',
    );

    final authLink = AuthLink(
      getToken: () => 'Bearer ${_userProfile.token}',
    );

    final Link link = authLink.concat(httpLink);

    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  /// 客户端
  GraphQLClient get created {
    return _client;
  }

  /// 设置全局状态
  void authorize(UserProfile userProfile) {
    _userProfile = userProfile;
  }
}
