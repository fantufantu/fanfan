import 'package:graphql/client.dart';
import 'package:fanfan/service/schemas/category.dart' show CATEGORY_FRAGMENT;

final CREATE_TRANSACTION = gql('''
  mutation CreateTransaction(\$createBy: CreateTransactionBy!) {
    createTransaction(createBy: \$createBy) {
      id
    }
  }
''');

final TRANSACTIONS = gql('''
  $CATEGORY_FRAGMENT
  query Transactions(\$filterBy: FilterTransactionBy!) {
    transactions(filterBy: \$filterBy) {
      items {
        id
        amount
        remark
        billingId
        happenedAt
        category {
          ...CategoryFragment
        }
      }
    }
  }
''');
