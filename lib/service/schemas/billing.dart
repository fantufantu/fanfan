import 'package:graphql/client.dart';

final BILLINGS = gql('''
  query Billings {
    billings {
      items {
        id
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
