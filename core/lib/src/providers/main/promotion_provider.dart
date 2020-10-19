import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class PromotionProvider {
  Future<FeedPromotionModel> promotion(String id) {
    return getGraphQLClient()
        .query(_queryOptions(id))
        .then(_toPromotionConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String id) {
    print(_readPromotionConnectionQuery(id));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readPromotionConnectionQuery(id)));
  }

  FeedPromotionModel _toPromotionConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final dynamic json = queryResult.data['promotion'];
    return FeedPromotionModel.fromJson(json);
  }

  String _readPromotionConnectionQuery(String id) => '''
    {
      promotion(where: {id: ${json.encode(id)}}) {
        id
        summary
        type
        name
        coverImage {
          url
        }
        actionLink {
          value
          target
        }
        products{
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
