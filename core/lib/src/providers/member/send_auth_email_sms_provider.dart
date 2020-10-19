import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

//send auth SMS for email find
class SendAuthEmailSmsProvider {
  Future<bool> sendAuthEmailSms(SendAuthMobileModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_authMobile)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(SendAuthMobileModel model) {
    print(' ${sendAuthEmailSmsQuery(model.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(sendAuthEmailSmsQuery(model.toJSON())));
  }

  bool _authMobile(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    print(queryResult.data['sendAuthEmailSms']);
    return queryResult.data['sendAuthEmailSms'];
  }

  String sendAuthEmailSmsQuery(Map<String, dynamic> model) => '''
  mutation{
    sendAuthEmailSms(input:$model)
  }  
  ''';
}
