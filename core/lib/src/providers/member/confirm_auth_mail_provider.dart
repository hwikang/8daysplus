import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

//use in email check
class ConfirmAuthMailProvider {
  Future<bool> confirmAuthMail(ConfirmEmailModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_confirmAuthMail)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(ConfirmEmailModel model) {
    print(' ${confirmAuthMailQuery(model.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(confirmAuthMailQuery(model.toJSON())));
  }

  bool _confirmAuthMail(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    return queryResult.data['confirmAuthMail'];
  }

  String confirmAuthMailQuery(Map<String, dynamic> model) => '''
  mutation{
    confirmAuthMail(input:$model)
  }  
  ''';
}
