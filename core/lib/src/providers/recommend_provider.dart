import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../core.dart';
import '../utils/graphql_client.dart';

class RecommendProvider {
  // RecommendProvider({this.neighbor});
  // final bool neighbor;
  // String passProductId = '';
  Future<List<ProductListViewModel>> recommendation(
      String productId, String typeName, bool neighbor) {
    // passProductId = productId;
    return getGraphQLClient()
        .query(_queryOptions(productId, typeName, neighbor))
        .then(_toRecommendation)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String productId, String typeName, bool neighbor) {
    print(
      readRecommendationQuery(productId, typeName, neighbor),
    );
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(readRecommendationQuery(productId, typeName, neighbor)),
    );
  }

  List<ProductListViewModel> _toRecommendation(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    final List<dynamic> list = queryResult.data['recommendationProduct'];
    print(list);
    return list
        .map((dynamic repoJson) => ProductListViewModel.fromJson(repoJson))
        .toList(growable: false);
  }
}

String readRecommendationQuery(
        String productId, String typeName, bool neighbor) =>
    '''
query getRecommendation {
  recommendationProduct(where: {
    type: $typeName,
    productId: ${json.encode(productId)},
    neighbor:$neighbor
  }) {
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
''';
