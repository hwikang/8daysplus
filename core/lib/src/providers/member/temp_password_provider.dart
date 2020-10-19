import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class TempPasswordProvider {
  Future<void> findPassword(FindPasswordInput input) {
    return getGraphQLClient()
        .query(_queryOptions(input))
        .then(_toFindPassword)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(FindPasswordInput input) {
    final query = findPasswordQuery(input.toJSON());
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly, documentNode: gql(query));
  }

  void _toFindPassword(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
  }
}

String findPasswordQuery(Map<String, dynamic> input) => '''
mutation {
  findPassword(
    input: $input
  )
}
''';
