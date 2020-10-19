import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../../../core.dart';

enum CategoryState { Content, Activity, Ecoupon }

class CategoryBloc {
  CategoryBloc({
    this.typeName,
    this.searchTypeName,
    this.categoryId,
    this.rootCategoryIndex = 0,
  }) {
    // networkState.add(NetworkState.Start);
    categoryType.add(typeName);
    fetch();
  }

  final String categoryId;
  final CategoryProvider categoryProvider = CategoryProvider();
  //선택된 루트 카테고리
  // final BehaviorSubject<CategoryState> selectedCategoryState =
  //     BehaviorSubject<CategoryState>();
  final BehaviorSubject<String> categoryType =
      BehaviorSubject<String>(); //experience , content

  // final BehaviorSubject<NetworkState> networkState =
  //     BehaviorSubject<NetworkState>();

  final BehaviorSubject<List<CategoryModel>> repoList =
      BehaviorSubject<List<CategoryModel>>();

  final BehaviorSubject<CategoryModel> rootCategory =
      BehaviorSubject<CategoryModel>(); //지역, 엑티비티

  final int rootCategoryIndex;
  final String searchTypeName;
  final String typeName;

  Future<bool> refresh() {
    return getCategories(typeName: typeName, searchTypeName: searchTypeName)
        .then((data) {
      // rootCategory.add(data[rootCategoryIndex]); //페이지 이동간 카테고리 유지
      repoList.add(data);
      // networkState.add(NetworkState.Normal);
      return true;
    }).catchError((error) => {repoList.addError(error)});
  }

  void fetch() {
    getCategories(
            typeName: typeName,
            searchTypeName: searchTypeName,
            categoryId: categoryId)
        .then((data) {
      if (data.isEmpty) {
        repoList.add(<CategoryModel>[]);
      } else {
        rootCategory.add(data[rootCategoryIndex]); //페이지 이동간 카테고리 유지
        repoList.add(data);
        // networkState.add(NetworkState.Normal);
      }
    }).catchError((error) => {repoList.addError(error)});
  }

  Future<List<CategoryModel>> getCategories(
      {String typeName, String searchTypeName, String categoryId}) {
    //검색결과 저장

    return categoryProvider
        .categories(
          typeName: typeName,
          searchTypeName: searchTypeName,
          categoryId: categoryId,
          // networkStateStream: networkState
        )
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
                // networkState: networkState, retry: fetch
              )
            });

    //     .timeout(const Duration(milliseconds: 10000), onTimeout: () {
    //   throw TimeoutException('time out in category bloc');
    // }).catchError((dynamic err) {
    //   NetworkErrorHandler.handleError(
    //       err: err,
    //       onNetworkError: () {
    //         networkState.add(NetworkState.NetworkError);
    //       },
    //       onLoginError: () {
    //         networkState.add(NetworkState.LoginError);
    //       },
    //       defaultError: () {
    //         networkState.add(NetworkState.Failed);
    //       });
    //   // throw err;
    // });
  }

  void dispose() {
    repoList.close();
    rootCategory.close();
    categoryType.close();
    // selectedCategoryState.close();
    // networkState.close();
  }
}
