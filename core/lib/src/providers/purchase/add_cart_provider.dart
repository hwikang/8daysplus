import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class AddCartProvider {
  Future<bool> addCart(OrderInfoProductModel product) {
    return getGraphQLClient()
        .query(_queryOptions(product))
        .then(_toAddCart)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(OrderInfoProductModel product) {
    final productQuery = <String, dynamic>{'orderProduct': product.toJson()};
    print(readAddCart(productQuery));
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(readAddCart(productQuery)),
    );
  }

  bool _toAddCart(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final bool result = queryResult.data['addCart'];
    print(result);
    return result;
  }

  String readAddCart(Map<String, dynamic> productQuery) => '''
    mutation {
      addCart(
        input: $productQuery
      )
    }
  ''';
}
