import 'package:fanfan/store/user_profile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Service {
  static final _instance = Service._internal();
  late GraphQLClient _client;
  late UserProfile _userProfile;

  Service._internal() {
    _userProfile = UserProfile();

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

  factory Service() => _instance;

  GraphQLClient get client {
    return _client;
  }
}
