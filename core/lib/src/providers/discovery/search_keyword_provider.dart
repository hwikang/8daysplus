import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class SearchKeywordProvider {
  Future<SearchKeywordModel> searchKeywordConnection(String keyword) {
    return getGraphQLClient()
        .query(_queryOptions(keyword))
        .then(_toSearchKeywordConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String keyword) {
    final query = readSearchKeywordConnectionQuery(keyword);
    print(query);
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly, documentNode: gql(query));
  }

  SearchKeywordModel _toSearchKeywordConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final Map<String, dynamic> json = queryResult.data['searchKeyword'];
    return SearchKeywordModel.fromJson(json);
  }

  String readSearchKeywordConnectionQuery(String keyword) => '''
  {
    searchKeyword(where: {
      keyword:${json.encode(keyword)},
    }) {
      recentKeywords
      bestKeywords
      products {
        tags
        id
        name
        createdAt
        typeName
        summary
        coverPrice
        salePrice
      	discountRate
        categories{
          id
          name
          nodes{
            id
            name
            nodes{
              id
              name
            }
          }
        }
        availableDateInfo  {
          name
          color 
        }
        coverImage {
          url
          width
          height
        }
        images {
          url
        }
      }
    }
    }
  ''';
}
