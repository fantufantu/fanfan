import 'package:fanfan/service/entities/billing/main.dart';
import 'package:fanfan/service/entities/billing/paginated_billings.dart';
import 'package:fanfan/service/entities/billing/limit_settings.dart';
import 'package:fanfan/service/schemas/billing.dart';
import 'package:fanfan/utils/service.dart';
import 'package:graphql/client.dart';

Future<PaginatedBillings> queryBillings() async {
  final response = await Client().query(
    QueryOptions(
      document: BILLINGS,
      fetchPolicy: FetchPolicy.noCache,
    ),
  );

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return PaginatedBillings.fromJson(response.data!['billings']);
}

Future<Billing> createBilling({
  required String name,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: CREATE_BILLING,
    variables: Map.from(
      {
        "createBy": {
          "name": name,
        }
      },
    ),
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '创建失败！')));
  }

  return Billing.fromJson(response.data!['createBilling']);
}

Future<Billing> queryBilling(int id) async {
  final response = await Client().query(
    QueryOptions(
      document: BILLING,
      variables: Map.from({
        "id": id,
      }),
      fetchPolicy: FetchPolicy.noCache,
    ),
  );

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '查询账本信息失败！')));
  }

  return Billing.fromJson(response.data!['billing']);
}

Future<bool> setDefault({
  required int id,
  required bool isDefault,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: SET_DEFAULT,
    variables: Map.from({
      "setBy": Map.from({
        "id": id,
        "isDefault": isDefault,
      })
    }),
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '设置默认账本失败！')));
  }

  return response.data!['setDefaultBilling'];
}

Future<bool> setLimit({
  required int id,
  required LimitSettings limitSettings,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: SET_LIMIT,
    variables: Map.from({
      "id": id,
      "setBy": limitSettings.toJson(),
    }),
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '限额设置失败！')));
  }

  return response.data!['setBillingLimit'];
}
