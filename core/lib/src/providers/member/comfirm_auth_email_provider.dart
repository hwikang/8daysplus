import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

//use in email find
class ConfirmAuthEmailProvider {
  Future<String> confirmAuthEmail(ConfirmAuthSmsModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_confirmAuthEmailSMS)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(ConfirmAuthSmsModel model) {
    print(' ${confirmAuthEmailSMSQuery(model.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(confirmAuthEmailSMSQuery(model.toJSON())));
  }

  String _confirmAuthEmailSMS(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data['confirmAuthEmail']);
    return queryResult.data['confirmAuthEmail'];
  }

  String confirmAuthEmailSMSQuery(Map<String, dynamic> model) => '''
  mutation{
    confirmAuthEmail(input:$model)
  }  
  ''';
}
