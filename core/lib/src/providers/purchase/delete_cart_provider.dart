import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class DeleteCartProvider {
  Future<bool> deleteCart(List<String> ids) {
    return getGraphQLClient()
        .query(_queryOptions(ids))
        .then(_toAddCart)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(List<String> ids) {
    print(removeCartQuery(ids));
    return QueryOptions(
      documentNode: gql(removeCartQuery(ids)),
    );
  }

  bool _toAddCart(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final bool result = queryResult.data['removeCart'];
    print(result);
    return result;
  }

  String removeCartQuery(List<String> ids) => '''
    mutation {
      removeCart(input:{
        ids: ${json.encode(ids)}
      })
    }
  ''';
}
