import 'package:fanfan/store/user_profile.dart';
import 'package:graphql/client.dart';

class Client extends GraphQLClient {
  /// 单例
  static Client? _clinet;

  factory Client() {
    return _clinet ??= Client._internal(
      link: AuthLink(
        getToken: () => 'Bearer ${UserProfile().token}',
      ).concat(
        HttpLink(
          // 'http://localhost:3900/graphql/',
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

/// 异常抛出
reject(
  List<GraphQLError> errors,
) {
  if ((errors).isEmpty) {
    throw const GraphQLError(message: '未知异常！');
  }

  throw errors.single;
}
