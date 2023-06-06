import 'package:graphql/client.dart';
import 'package:fanfan/service/schemas/user.dart' show USER_FRAGMENT;
import 'package:fanfan/service/schemas/category.dart' show CATEGORY_FRAGMENT;

final INITIALIZE = gql('''
  $USER_FRAGMENT
  $CATEGORY_FRAGMENT
  query ApplicationInitialize {
    whoAmI {
      ...UserFragment
    }
    categories {
      items {
        ...CategoryFragment
      }
    }
  }
''');
