import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class ExistCompanyCodeProvider {
  Future<bool> existCompanyCode(String corpCode) {
    return getGraphQLClient()
        .query(_queryOptions(corpCode))
        .then(toExistsCompanyCode)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(String corpCode) {
    print(existsCompanyCodeQuery(corpCode));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(existsCompanyCodeQuery(corpCode)));
  }

  bool toExistsCompanyCode(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    return queryResult.data['existsCompanyCode'];
  }

  String existsCompanyCodeQuery(String corpCode) => '''
  {  
    existsCompanyCode(input:{
      companyCode:${json.encode(corpCode)}
    })
  }

  ''';
}
