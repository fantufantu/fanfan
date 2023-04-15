import 'package:fanfan/store/user_profile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Client extends GraphQLClient {
  /// 单例
  static Client? _clinet;

  factory Client() {
    return _clinet ??= Client._internal(
      link: AuthLink(
        getToken: () => 'Bearer ${UserProfile().token}',
      ).concat(
        HttpLink(
          'https://api.fantufantu.com/',
        ),
      ),
      cache: GraphQLCache(),
    );
  }

  Client._internal({
    required super.link,
    required super.cache,
  });
}
