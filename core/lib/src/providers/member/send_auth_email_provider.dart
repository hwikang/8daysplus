import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

//send auth email for sign up
class AuthEmailProvider {
  Future<bool> authEmail(AuthEmailModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_authEmail)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(AuthEmailModel model) {
    print(' ${authEmailQuery(model.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(authEmailQuery(model.toJSON())));
  }

  bool _authEmail(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    getLogger(this).i('sendAuthMail ${queryResult.data["sendAuthMail"]}');
    return queryResult.data['sendAuthMail'];
  }

  String authEmailQuery(Map<String, dynamic> model) => '''
  mutation{
    sendAuthMail(input:$model)
  }  
  ''';
}
