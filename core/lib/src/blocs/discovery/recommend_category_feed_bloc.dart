import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core.dart';

class RecommendCategoryFeedBloc {
  BehaviorSubject<String> categoryIdState = BehaviorSubject<String>();
  // final BehaviorSubject<NetworkState> networkState =
  //     BehaviorSubject<NetworkState>();

  RecommendCategoryFeedProvider recommendCategoryFeedProvider =
      RecommendCategoryFeedProvider();

  BehaviorSubject<List<FeedModel>> repoList =
      BehaviorSubject<List<FeedModel>>();

  BehaviorSubject<String> typeState = BehaviorSubject<String>();

  Future<bool> fetch() {
    // networkState.add(NetworkState.Retry);
    return recommendCategoryFeedProvider
        .recommendCategoryFeed(typeState.value, categoryIdState.value)
        .then((data) {
      repoList.add(data);
      // networkState.add(NetworkState.Normal);
      return true;
    }).catchError((error) => {repoList.addError(error)});
  }

  //add "Last Requested Query Result" to repoList when we click two button at a time
  String lastQueriedCategoryId = '';
  Future<bool> changeRecommendCategory(String type, String categoryId) {
    // networkState.add(NetworkState.Changing);
    lastQueriedCategoryId = categoryId;
    return getRecommendCategoryFeed(type, categoryId).then((data) {
      if (lastQueriedCategoryId == categoryId) {
        repoList.add(data);
      }

      // networkState.add(NetworkState.Normal);
      return true;
    }).catchError((error) => {repoList.addError(error)});
  }

  Future<List<FeedModel>> getRecommendCategoryFeed(
      String type, String categoryId) {
    typeState.add(type);
    categoryIdState.add(categoryId);

    return recommendCategoryFeedProvider
        .recommendCategoryFeed(type, categoryId)
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
              )
            });
  }

  void dispose() {
    // repoList.close();
    typeState.close();
    categoryIdState.close();
  }
}
