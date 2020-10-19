import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/discovery/basic_search_filter_model.dart';

class BasicSearchFilterProvider {
  Future<BasicSearchFilterModel> searchFilter({String productType}) {
    return getGraphQLClient()
        .query(_queryOptions(
          productType: productType,
        ))
        .then(_toSearchFilter)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions({String productType}) {
    print(readCategoryQuery(productType));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readCategoryQuery(productType)));
  }

  BasicSearchFilterModel _toSearchFilter(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    final Map<String, dynamic> searchFilterJson =
        queryResult.data['searchFilter'];

    return BasicSearchFilterModel.fromJson(searchFilterJson);
  }

  String readCategoryQuery(String productType) => '''
  {
    searchFilter(productType: $productType) {
      orderby {
        direction
        field
        label
      }
      priceRange {
        min
        max
        label
      }
    }
  }
  ''';
}
