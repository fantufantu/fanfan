import 'package:graphql/client.dart';

const CATEGORY_FRAGMENT = '''
  fragment CategoryFragment on Category {
    id
    name
    direction
  }
''';

final CATEGORIES = gql('''
  $CATEGORY_FRAGMENT
  query Categories {
    categories {
      items {
        ...CategoryFragment
      }
    }
  }
''');
