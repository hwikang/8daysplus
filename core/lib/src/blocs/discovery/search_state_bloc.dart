import 'package:rxdart/rxdart.dart';

import '../../../core.dart';

enum SearchBodyState { Suggestion, Result }

class SearchStateBloc {
  SearchStateBloc({this.initSearchBodyState = SearchBodyState.Suggestion}) {
    searchBodyState.add(initSearchBodyState);
    searchTabState.add(0);
    _searchFilterModelList =
        List<SearchFilterModel>.generate(5, (_) => SearchFilterModel());
    searchFilterModels.add(_searchFilterModelList);
  }

  //all body state manage
  BehaviorSubject<bool> allBodyEmpty = BehaviorSubject<bool>();

  SearchBodyState initSearchBodyState;
  List<bool> isEmptyList = <bool>[];
  BehaviorSubject<SearchBodyState> searchBodyState =
      BehaviorSubject<SearchBodyState>();

  BehaviorSubject<List<SearchFilterModel>> searchFilterModels =
      BehaviorSubject<List<SearchFilterModel>>();

  BehaviorSubject<int> searchTabState = BehaviorSubject<int>();

  List<SearchFilterModel> _searchFilterModelList;

  void addIsEmptyState(bool isEmpty) {
    isEmptyList.add(isEmpty);
  }

  void changeAllBodyEmptyState(bool isAllEmpty) {
    allBodyEmpty.add(isAllEmpty);
    print(allBodyEmpty.value);
  }

  void changeSearchFilterModel(int tabIndex, SearchFilterModel model) {
    _searchFilterModelList[tabIndex] = model;
    print(_searchFilterModelList);
    searchFilterModels.add(_searchFilterModelList);
  }

  void changeTabState(int tabIndex) {
    isEmptyList.clear();
    searchTabState.add(tabIndex);
  }

  void changeBodyState(SearchBodyState state) {
    searchBodyState.add(state);
    allBodyEmpty.add(false);
    isEmptyList.clear();
  }

  void dispose() {
    searchBodyState.close();
    searchTabState.close();
    searchFilterModels.close();
  }
}
