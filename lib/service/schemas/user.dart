import 'package:graphql/client.dart';

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
