import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class RecommendCategoryFeedProvider {
  Future<List<FeedModel>> recommendCategoryFeed(
      String type, String categoryId) {
    type ??= 'EXPERIENCE';
    categoryId ??= '';

    return getGraphQLClient()
        .query(_queryOptions(type, categoryId))
        .then(_toRecommendCategoryFeed)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String type, String categoryId) {
    print(readRecommendCategoryFeed(type, categoryId));
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(readRecommendCategoryFeed(type, categoryId)),
    );
  }

  List<FeedModel> _toRecommendCategoryFeed(QueryResult queryResult) {
    // print(queryResult.);
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['recommendCategoryFeed'];
    final repoList = list.map((dynamic model) {
      return FeedModel.fromJson(model);
    }).toList();

    return repoList;
  }

  String readRecommendCategoryFeed(String type, String categoryId) => '''
  {
	recommendCategoryFeed(where: {
    type: $type
    categoryId: ${json.encode(categoryId)}
  }) {
    __typename
   
   	... on FeedGridProducts {
      id
      title
      subTitle
      labelType
      bannerView
      overView
      actionLink{
        value
        target
      }
      subMessage
      feedGridProducts {
        tags
        id
        name
        createdAt
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
        typeName
        summary
        coverPrice
        salePrice
      	discountRate
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
}
