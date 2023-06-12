import 'package:graphql/client.dart';
import 'package:fanfan/service/schemas/billing.dart';

const USER_FRAGMENT = '''
  $BILLING_FRAGMENT
  fragment UserFragment on User {
    id
    username
    emailAddress
    avatar
    defaultBilling {
      ...BillingFragment
    }
  }
''';

final WHO_AM_I = gql('''
  $USER_FRAGMENT
  query WhoAmI {
    whoAmI {
      ...UserFragment
    }
  }
''');

final DEFAULT_BILLING = gql('''
  $BILLING_FRAGMENT
  query WhoAmI {
    whoAmI {
      defaultBilling {
        ...BillingFragment
      }
    }
  }
''');

final USERS = gql(r'''
  query Users($who: String!) {
    users(who: $who) {
      id
      username
      emailAddress
      avatar
    }
  }
''');
