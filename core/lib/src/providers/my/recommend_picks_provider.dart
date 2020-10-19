import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class RecommendPicksProvider {
  Future<Map<String, dynamic>> recommendPicks() {
    return getGraphQLClient().query(_queryOptions()).then(_toRecommendPicks);
  }

  QueryOptions _queryOptions() {
    return QueryOptions(documentNode: gql(_readRecommendPicksQuery()));
  }

  Map<String, dynamic> _toRecommendPicks(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    // print(queryResult.data);
    final jsonData = queryResult.data['recommendPicks'];
    final node = <String, dynamic>{};
    node['title'] = jsonData['title'];
    final List<dynamic> feedPickProducts = jsonData['feedPickProducts'];
    node['feedPickProducts'] = feedPickProducts.map((dynamic pickProducts) {
      return ProductListViewModel.fromStylePick(pickProducts);
    }).toList();

    return node;
  }

  String _readRecommendPicksQuery() {
    return '''
   {
  recommendPicks {
    ... on FeedPickProducts {
      title
      labelType
      feedPickProducts {
        id
        name
        typeName
         coverImage{
          url
        }
        tags
      }
    }
  }
}
''';
  }
}
