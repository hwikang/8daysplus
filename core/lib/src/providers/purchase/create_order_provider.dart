import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../blocs/purchase/payment_bloc.dart';
import '../../utils/graphql_client.dart';

class CreateOrderProvider {
  Future<String> createOrder(String orderId, PaymentModel paymentModel) {
    return getGraphQLClient()
        .query(_queryOptions(orderId, paymentModel))
        .then(_toCreateOrder)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String orderId, PaymentModel paymentModel) {
    final paymentQuery = paymentModel.toJson();
    final query = readOrderInfoRequest(orderId, paymentQuery);
    print(query);
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(query),
    );
  }

  String _toCreateOrder(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    print(queryResult.data['createOrder']);
    final String url = queryResult.data['createOrder'];
    return url;
  }

  String readOrderInfoRequest(
          String orderId, Map<String, dynamic> paymentQuery) =>
      '''
    mutation {	
      createOrder(input: {
        orderId: ${json.encode(orderId)},
        payment: $paymentQuery
      })
    }
    ''';
}
