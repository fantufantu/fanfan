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
        createdBy {
          id
          username
          emailAddress
          avatar
        }
        createdAt
      }
    }
  }
''');

final DEFAULT_BILLING = gql('''
  query WhoAmI {
    whoAmI {
      defaultBilling {
        id
        name
        createdBy {
          id
          username
          emailAddress
          avatar
        }
        createdAt
      }
    }
  }
''');
