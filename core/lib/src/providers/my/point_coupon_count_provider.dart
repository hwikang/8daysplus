import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class PointCouponCountProvier {
  Future<Map<String, dynamic>> pointCouponCount() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_topointCouponCount)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions() {
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readpointCouponCount()));
  }

  Map<String, dynamic> _topointCouponCount(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final result = <String, dynamic>{};

    print(queryResult.data);
    result['lifePoint'] = queryResult.data['lifePoint'];
    result['couponCount'] =
        queryResult.data['couponStateCount']['enabledCount'];

    return result;
  }

  String _readpointCouponCount() {
    return '''
    {
       lifePoint
       couponStateCount {
        enabledCount
        disabledCount
      }
    }
''';
  }
}
