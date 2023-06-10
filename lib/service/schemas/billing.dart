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
      limitAmount
      limitDuration
    }
  }
''');

final SET_DEFAULT = gql(r'''
  mutation SetDefaultBilling($setBy: SetDefaultBillingBy!) {
    setDefaultBilling(setBy: $setBy)
  }
''');

final SET_LIMIT = gql(r'''
  mutation SetBillingLimit($id: Int!, $setBy: SetBillingLimitBy!) {
    setBillingLimit(id: $id, setBy: $setBy)
  }
''');
