import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class VerifyEmailProvider {
  Future<bool> verifyEmail(VerifyEmailModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_verify)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(VerifyEmailModel model) {
    print(' ${verifyEmailQuery(model.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(verifyEmailQuery(model.toJSON())));
  }

  bool _verify(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(' ${queryResult.data['verifyEmail']}');
    return queryResult.data['verifyEmail'];
  }

  // String verifyEmailQuery(Map<String, dynamic> model) => '''
  // mutation{
  //   sendVerifyEmail(input:$model)
  // }
  // ''';

  String verifyEmailQuery(Map<String, dynamic> model) => '''
  mutation{
    verifyEmail(input:$model)
  }  
  ''';
}
