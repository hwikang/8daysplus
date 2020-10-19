import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';

class SearchKeywordBloc {
  SearchKeywordBloc({
    this.keyword,
  }) {
    search(keyword);
  }

  String keyword;
  BehaviorSubject<SearchKeywordModel> repoList =
      BehaviorSubject<SearchKeywordModel>();

  SearchKeywordProvider searchKeywordProvider = SearchKeywordProvider();

  void search(String keyword) {
    getSearchKeyword(keyword).then((data) {
      repoList.add(data);
    }).catchError((error) => {repoList.addError(error)});
  }

  Future<SearchKeywordModel> getSearchKeyword(String keyword) {
    return searchKeywordProvider
        .searchKeywordConnection(keyword)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  void dispose() {
    repoList.close();
  }
}
