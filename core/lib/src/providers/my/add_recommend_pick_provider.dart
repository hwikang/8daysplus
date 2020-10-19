import 'package:graphql/client.dart';

import '../../../core.dart';

class AddRecommendPickProvider {
  Future<bool> addRecommendPick(AddRecommendPickInputModel inputModel) {
    return getGraphQLClient()
        .query(_queryOptions(inputModel))
        .then(_toAddRecommendPick);
  }

  QueryOptions _queryOptions(AddRecommendPickInputModel inputModel) {
    print(readAddRecommendPickQuery(inputModel.toJSON()));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readAddRecommendPickQuery(inputModel.toJSON())));
  }

  bool _toAddRecommendPick(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final bool result = queryResult.data['addRecommendPick'];

    // print('list $list');
    return result;
  }

  String readAddRecommendPickQuery(Map<String, dynamic> inputJson) => '''
  
  mutation{
  addRecommendPick(input:$inputJson)
}
  ''';
}
