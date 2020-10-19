import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class RecommendAnalysisProvider {
  Future<List<FeedModel>> recommendAnalysis() {
    return getGraphQLClient().query(_queryOptions()).then(_toRecommendAnalysis);
  }

  QueryOptions _queryOptions() {
    print(readRecommendAnalysisQuery());
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readRecommendAnalysisQuery()));
  }

  List<FeedModel> _toRecommendAnalysis(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['recommendAnalysis'];
    final styleList = list.map((dynamic style) {
      return FeedModel.fromJson(style);
    }).toList();
    return styleList;
  }

  String readRecommendAnalysisQuery() {
    return '''
{
  recommendAnalysis {
       __typename
       ... on FeedStyleAnaylze {
        title
        subTitle
        labelType
        bannerView
        overView
        subMessage
        actionLink{
          target
          value
        }
      }
     ... on FeedSummary {
      title
        subTitle
         labelType
      bannerView
      overView
      subMessage
      actionLink{
        target
        value
      }
			feedSummary {
        name
        score
      }
    }
    
    ... on FeedSmallSlideProducts {
      title
      labelType
      bannerView
      overView
      subMessage
      actionLink{
        target
        value
      }
     	feedSmallSlideProducts {
         id
          name
          summary
          typeName
          tags
          discountRate
          availableDateInfo{
             name
             color            
          }
          coverImage {
            url
          }
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
          coverPrice
          salePrice

      }
    }
	  ... on FeedBigSlideProducts {
      title
      labelType
      bannerView
      overView
      subMessage
      actionLink{
        target
        value
      }
      feedBigSlideProducts {
         id
          name
          summary
          typeName
          tags
          discountRate
          availableDateInfo{
             name
             color            
          }
          coverImage {
            url
          }
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
          coverPrice
          salePrice
      }
    }
  }
}
    ''';
  }
}
