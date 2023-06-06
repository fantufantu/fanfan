import 'package:graphql/client.dart';

const BILLING_FRAGMENT = '''
  fragment BillingFragment on Billing {
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
''';

final BILLINGS = gql('''
  $BILLING_FRAGMENT
  query Billings {
    billings {
      items {
        ...BillingFragment
      }
      total
    }
  }
''');

final CREATE_BILLING = gql('''
  mutation CreateBilling(\$createBy: CreateBillingBy!) {
    createBilling(createBy: \$createBy) {
      id
    }
  }
''');

final BILLING = gql('''
  $BILLING_FRAGMENT
  query Billing(\$id: Int!) {
    billing(id: \$id) {
      ...BillingFragment
    }
  }
''');

final SET_DEFAULT = gql('''
  mutation SetDefaultBilling(\$setBy: SetDefaultBillingBy!) {
    setDefaultBilling(setBy: \$setBy)
  }
''');
