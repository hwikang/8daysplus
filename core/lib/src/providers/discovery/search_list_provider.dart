import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class SearchListProvider {
  String tProductType = '';
  Future<Map<String, dynamic>> searchConnection(
      {int first,
      String after,
      OrderByModel orderBy,
      SearchInputModel searchInputModel}) {
    tProductType = searchInputModel.types[0];
    return getGraphQLClient()
        .query(_queryOptions(
          first: first,
          after: after,
          orderBy: orderBy,
          searchInputModel: searchInputModel,
        ))
        .then(_toSearchConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(
      {int first,
      String after,
      OrderByModel orderBy,
      SearchInputModel searchInputModel}) {
    final query = readSearchConnectionQuery(
      first,
      after,
      orderBy,
      searchInputModel,
    );
    print(query);
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(query),
    );
  }

  Map<String, dynamic> _toSearchConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    final List<dynamic> list = queryResult.data['searchConnection']['edges'];
    print(list);
    final dynamic totalCount =
        queryResult.data['searchConnection']['totalCount'];

    final bool hasNextPage =
        queryResult.data['searchConnection']['pageInfo']['hasNextPage'];
    final String endCursor =
        queryResult.data['searchConnection']['pageInfo']['endCursor'];

    final edges = list.map((dynamic repoJson) {
      return ProductListViewModel.fromJson(repoJson['node']);
    }).toList(growable: false);

    final map = <String, dynamic>{
      'totalCount': totalCount,
      'edges': edges,
      'endCursor': endCursor,
      'hasNextPage': hasNextPage
    };
    print(map);
    return map;
  }
}

String readSearchConnectionQuery(
  int first,
  String after,
  OrderByModel orderBy,
  SearchInputModel searchInputModel,
) =>
    '''
query searchConnection{
  searchConnection(
    first:$first
    after:${json.encode(after)}
    orderBy:${orderBy.toJSON()}
    where: ${searchInputModel.toJSON()}
  ) {
    totalCount
    pageInfo {
      endCursor
      hasNextPage
    }
    edges {
      cursor
      node {
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
}
''';
