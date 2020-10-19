import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/create_refund_model.dart';
import '../../utils/graphql_client.dart';

class CreateRefundProvider {
  Future<bool> createOrderRefundRequest(CreateRefundModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_toCartConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(CreateRefundModel model) {
    print(readCreateOrderRefundQuery(model));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readCreateOrderRefundQuery(model)));
  }

  bool _toCartConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final bool res = queryResult.data['createOrderRefundRequest'];
    print(res);

    return res;
  }

  String readCreateOrderRefundQuery(CreateRefundModel model) => ''' 
mutation{
  createOrderRefundRequest (input:${model.toJson()})
}

  
  ''';
}
