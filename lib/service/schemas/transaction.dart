import 'package:fanfan/service/schemas/billing.dart';
import 'package:graphql/client.dart';
import 'package:fanfan/service/schemas/category.dart' show CATEGORY_FRAGMENT;

final CREATE = gql('''
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

/// 根据id获取交易明细
final TRANSACTION = gql('''
  $CATEGORY_FRAGMENT
  $BILLING_FRAGMENT
  query Transaction(\$id: Int!) {
    transaction(id: \$id) {
      id
      amount
      happenedAt
      remark
      category {
        ...CategoryFragment
      }
      createdBy {
        username
        nickname
      }
      billing {
        ...BillingFragment
      }
    }
  }
''');

/// 根据id删除
final REMOVE_BY_ID = gql(r'''
  mutation RemoveTransaction($id: Int!) {
    removeTransaction(id: $id)
  }
''');

/// 更新
final UPDATE_BY_ID = gql(r'''
  mutation UpdateTransaction($id: Int!, $updateBy: UpdateTransactionBy!) {
    updateTransaction(id: $id, updateBy: $updateBy)
  }
''');

/// 查询按分类合计的交易金额
final AMOUNTS_GROUPED_BY_CATEGORY = gql('''
  query TransactionAmountsGroupedByCategory(\$grounBy: GroupTransactionAmountByCategory!) {
    transactionAmountsGroupedByCategory(groupBy: \$grounBy) {
      categoryId
      amount
    }
  }
''');

/// 查询按分类合计的交易金额，同时查询交易列表
final AMOUNTS_GROUPED_BY_CATEGORY_WITH_TRANSACTIONS = gql('''
  $CATEGORY_FRAGMENT
  query TransactionAmountsGroupedByCategory(\$grounBy: GroupTransactionAmountByCategory!, \$filterBy: FilterTransactionBy!) {
    transactionAmountsGroupedByCategory(groupBy: \$grounBy) {
      categoryId
      amount
    }
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
