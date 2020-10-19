import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class ProductAvailableDatesProvider {
  Future<List<ProductAvailableDateModel>> productAvailableDates(String id) {
    return getGraphQLClient()
        .query(_queryOptions(id))
        .then(_toProductAvailableDates)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String id) {
    print('query ${readProductAvailableDatesQuery(id)}');
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(readProductAvailableDatesQuery(id)),
    );
  }

  // ProductAvailableDateModel _toProductAvailableDates(QueryResult queryResult) {
  //   if (queryResult.hasErrors) {
  //     throw Exception();
  //   }
  //   final dynamic json = queryResult.data['productAvailableDates'] as dynamic;
  //   return ProductAvailableDateModel.fromJson(json);
  // }

  List<ProductAvailableDateModel> _toProductAvailableDates(
      QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['productAvailableDates'];
    return list.map((dynamic repoJson) {
      return ProductAvailableDateModel.fromJson(repoJson);
    }).toList(growable: false);
  }
}

String readProductAvailableDatesQuery(String id) => '''
query productAvailableDates {
  productAvailableDates(
    where: {
      id: ${json.encode(id)},
    }
  ) {
    day

    timeSchedules {
      id
      name
      lessonEndTime
      lessonStartTime
      possibleNumber
      minNum
      maxNum
      remainNum
      regNum
    }
    
    options {
      id
      name
      summary
      timeSlots {
        id
        startTime
        endTime
      }
       optionItems {
        id
        name
        category
        cnt
        minBuyItem
        maxBuyItem
        salePrice
        coverPrice
      }
    }
  }
}
''';
