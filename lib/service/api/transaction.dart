import 'package:fanfan/service/entities/transaction/editable.dart';
import 'package:fanfan/service/entities/transaction/amount_grouped_by_category.dart';
import 'package:fanfan/service/entities/transaction/filter_by.dart';
import 'package:fanfan/service/entities/transaction/group_by.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/entities/transaction/paginated_transactions.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
import 'package:fanfan/service/schemas/transaction.dart';
import 'package:fanfan/utils/service.dart';
import 'package:graphql/client.dart';
import 'package:tuple/tuple.dart';

/// 创建
Future<Transaction> create({
  required Editable editable,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: CREATE,
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

/// 查询列表
Future<PaginatedTransactions> queryTransactions({
  required FilterBy filterBy,
  required PaginateBy paginateBy,
}) async {
  final response = await Client().query(
    QueryOptions(
      document: TRANSACTIONS,
      variables: {
        "filterBy": filterBy.toJson(),
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
Future<bool> removeById(int id) async {
  final response = await Client().mutate(MutationOptions(
    document: REMOVE_BY_ID,
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

/// 更新
Future<bool> updateById({
  required int id,
  required Editable editable,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: UPDATE_BY_ID,
    variables: Map.from(
      {
        "id": id,
        "updateBy": editable.toJson(),
      },
    ),
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '更新失败！')));
  }

  return response.data!['updateTransaction'];
}

/// 查询统计数据
Future<Tuple2<List<AmountGroupedByCategory>, PaginatedTransactions?>>
    queryTransactionAmountsGroupedByCategory({
  bool withTransaction = false,
  required GroupBy groupBy,
  PaginateBy? paginateBy,
}) async {
  assert(withTransaction && paginateBy != null, '查询交易列表时，必须携带分页参数');

  final variables = Map<String, dynamic>.from({
    "grounBy": groupBy.toJson(),
  });

  // 查询交易需要附带的查询条件
  if (withTransaction) {
    variables.addAll({
      "filterBy": FilterBy(
        billingId: groupBy.billingId,
        categoryIds: groupBy.categoryIds,
        happenedFrom: groupBy.happenedFrom,
        happenedTo: groupBy.happenedTo,
      ).toJson(),
      "paginateBy": paginateBy?.toJson(),
    });
  }

  final response = await Client().query(QueryOptions(
    document: withTransaction
        ? AMOUNTS_GROUPED_BY_CATEGORY_WITH_TRANSACTIONS
        : AMOUNTS_GROUPED_BY_CATEGORY,
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return Tuple2(
    (response.data!['transactionAmountsGroupedByCategory'] as List<dynamic>)
        .map((e) => AmountGroupedByCategory.fromJson(e))
        .toList(),
    response.data!['transactions'] != null
        ? PaginatedTransactions.fromJson(response.data!['transactions'])
        : null,
  );
}
