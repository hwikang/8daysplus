import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class ExistsEmailProvider {
  Future<Map<String, dynamic>> existEmail(
      ExistsEmailModel model, String corpCode) {
    return getGraphQLClient()
        .query(_queryOptions(model, corpCode))
        .then(_exist)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(ExistsEmailModel model, String corpCode) {
    print(' ${existsEmailQuery(model.toJSON(), corpCode)}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(existsEmailQuery(model.toJSON(), corpCode)));
  }

  Map<String, dynamic> _exist(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);

      throw queryResult.exception;
    }
    return queryResult.data;
  }

  String existsEmailQuery(Map<String, dynamic> model, String corpCode) => '''
  {
   existsEmail(
    input: $model
  )
  existsCompanyCode(input:{
    companyCode:${json.encode(corpCode)}
  })
}

  ''';
}
