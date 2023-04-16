import 'package:graphql_flutter/graphql_flutter.dart';

final WHO_AM_I = gql('''
  query WhoAmI {
    whoAmI {
      id
      username
      emailAddress
      avatar
      defaultBilling {
        id
        name
      }
    }
  }
''');
