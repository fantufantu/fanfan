import 'package:fanfan/service/entities/transaction/editable.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/entities/transaction/paginated_transactions.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
import 'package:fanfan/service/schemas/transaction.dart';
import 'package:fanfan/utils/service.dart';
import 'package:graphql/client.dart';

Future<Transaction> createTransaction({
  required Editable editable,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: CREATE_TRANSACTION,
    variables: Map.from(
      {
        "createBy": editable.toJson(),
      },
    ),
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '创建失败！')));
  }

  return Transaction.fromJson(response.data!['createTransaction']);
}

Future<PaginatedTransactions> queryTransactions({
  required int billingId,
  required PaginateBy paginateBy,
}) async {
  final response = await Client().query(
    QueryOptions(
      document: TRANSACTIONS,
      variables: {
        "filterBy": {
          "billingId": billingId,
        },
        "paginateBy": paginateBy.toJson(),
      },
      fetchPolicy: FetchPolicy.noCache,
    ),
  );

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return PaginatedTransactions.fromJson(response.data!['transactions']);
}

/// 根据id获取交易明细
Future<Transaction> queryTransactionById(int id) async {
  final response = await Client().query(
    QueryOptions(
      document: TRANSACTION,
      variables: {
        "id": id,
      },
      fetchPolicy: FetchPolicy.noCache,
    ),
  );

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return Transaction.fromJson(response.data!['transaction']);
}

/// 根据id删除交易
Future<bool> removeTransactionById(int id) async {
  final response = await Client().mutate(MutationOptions(
    document: REMOVE_TRANSACTION,
    variables: {
      "id": id,
    },
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '删除失败！')));
  }

  return response.data!['removeTransaction'];
}
