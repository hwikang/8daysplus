import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../core.dart';
import '../utils/graphql_client.dart';

class ApplyCouponProvider {
  Future<ApplyCouponModel> applyCoupon(String couponId) {
    return getGraphQLClient()
        .query(_queryOptions(couponId))
        .then(_toApplyCoupon)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String couponId) {
    print(readAddRecommendPickQuery(couponId));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readAddRecommendPickQuery(couponId)));
  }

  ApplyCouponModel _toApplyCoupon(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final result = queryResult.data['applyCoupon'];
    final model = ApplyCouponModel.fromJson(result);

    return model;
  }

  String readAddRecommendPickQuery(String couponId) => '''
    mutation{
      applyCoupon(input:{
        couponID:${json.encode(couponId)}
      }){
        status
        message
      }
    }
  ''';
}
