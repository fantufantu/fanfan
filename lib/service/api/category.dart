import 'package:fanfan/service/entities/paginated_categories.dart';
import 'package:fanfan/utils/service.dart';
import 'package:fanfan/service/schemas/category.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<PaginatedCategories> queryCategories() async {
  final response = await Client().query(
    QueryOptions(
      document: CATEGORIES,
    ),
  );

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return PaginatedCategories.fromJson(response.data!['categories']);
}
