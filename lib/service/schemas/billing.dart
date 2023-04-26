import 'package:graphql/client.dart';

final BILLINGS = gql('''
  query Billings {
    billings {
      items {
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
      total
    }
  }
''');

final CREATE_BILLING = gql('''
  mutation CreateBilling(\$createBillingBy: CreateBillingBy!) {
    createBilling(createBillingBy: \$createBillingBy) {
      id
    }
  }
''');
