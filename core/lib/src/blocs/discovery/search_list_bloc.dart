import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../providers/discovery/search_list_provider.dart';

class SearchListBloc with Validators {
  SearchListBloc({
    this.first = 20,
    this.after = '',
    this.keyword = '',
    @required this.type,
    this.orderBy = const OrderByModel(),
    this.categoryRegionIds = '',
    this.categoryIds = '',
    this.priceRange = const PriceRangeModel(),
  }) {
    networkState.add(NetworkState.Start);
    search(
      after: after,
      orderBy: orderBy,
      categoryIds: categoryIds,
      categoryRegionIds: categoryRegionIds,
      type: type,
      keyword: keyword,
      priceRange: priceRange,
    );
  }

  final String after;
  final String categoryIds;
  final String categoryRegionIds;
  final int first;
  final String keyword;
  final PriceRangeModel priceRange;
  final BehaviorSubject<SearchInputModel> searchInputController =
      BehaviorSubject<SearchInputModel>();

  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  final OrderByModel orderBy;
  final BehaviorSubject<OrderByModel> orderByController =
      BehaviorSubject<OrderByModel>();

  final BehaviorSubject<List<ProductListViewModel>> searchList =
      BehaviorSubject<List<ProductListViewModel>>();

  final SearchListProvider searchListProvider = SearchListProvider();
  final String type;

  String _lastCursor = '';
  int _totalCount = 0;
  List<ProductListViewModel> _listAll;
  SearchInputModel _searchInputModel = SearchInputModel();

  String getAfter() => _lastCursor;
  OrderByModel getOrderBy() => orderByController.value;

  SearchInputModel getSearchInput() => searchInputController.value;

  String getKeyword() => getSearchInput().keyword;

  int getTotalCount() => _totalCount;
  void changeKeyword(String keyword) {
    _searchInputModel.keyword = keyword;
    searchInputController.add(_searchInputModel);
  }

  void clearSearchList() {
    searchList.add(<ProductListViewModel>[]);
  }

  void getMoreSearch() {
    networkState.add(NetworkState.Loading);
    getSearchList(
            // first: getFirst(),
            after: _lastCursor,
            orderBy: getOrderBy(),
            searchInputModel: getSearchInput())
        .then((data) {
      _lastCursor = data['endCursor'];

      final List<ProductListViewModel> newList = data['edges'];
      _listAll = List<ProductListViewModel>.from(searchList.value)
        ..addAll(newList);
      searchList.add(_listAll);

      if (!data['hasNextPage']) {
        networkState.add(NetworkState.Finish);
      } else {
        networkState.add(NetworkState.Normal);
      }
    });
  }

  void search({
    String after,
    OrderByModel orderBy,
    String keyword,
    String type,
    String categoryRegionIds,
    String categoryIds,
    PriceRangeModel priceRange,
    LocationModel location,
  }) {
    networkState.add(NetworkState.Start);

    _searchInputModel = SearchInputModel(
        categoryIds: categoryIds != null
            ? <String>[categoryIds]
            : _searchInputModel.categoryIds,
        categoryRegionIds: categoryRegionIds != null
            ? <String>[categoryRegionIds]
            : _searchInputModel.categoryRegionIds,
        location: location ?? _searchInputModel.location,
        keyword: keyword ?? _searchInputModel.keyword,
        types: <String>[type ?? _searchInputModel.types[0]],
        priceRange: priceRange ?? _searchInputModel.priceRange,
        state: _searchInputModel.state);

    getSearchList(
      after: after ?? '',
      orderBy: orderBy ?? getOrderBy(),
      searchInputModel: _searchInputModel,
    ).then((data) {
      _totalCount = data['totalCount'];

      final List<ProductListViewModel> list = data['edges'];

      if (list.isNotEmpty) {
        _lastCursor = data['endCursor'];
        print('list $list');
        searchList.add(list);
        _listAll = List<ProductListViewModel>.from(list);

        //더 fetch할게 없으면 스탑
        if (!data['hasNextPage']) {
          networkState.add(NetworkState.Finish);
        } else {
          networkState.add(NetworkState.Normal);
        }
      } else {
        print('result data is empty');
        clearSearchList();
        networkState.add(NetworkState.Normal);
      }
    });
  }

  Future<Map<String, dynamic>> getSearchList({
    String after,
    OrderByModel orderBy,
    SearchInputModel searchInputModel,
  }) {
    saveLastSearchInputData(after, orderBy, searchInputModel);

    return searchListProvider
        .searchConnection(
            first: first,
            after: after,
            orderBy: orderBy,
            searchInputModel: searchInputModel)
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: search)
            });
  }

  void saveLastSearchInputData(
    String after,
    OrderByModel orderBy,
    SearchInputModel searchInputModel,
  ) {
    _lastCursor = after;

    orderByController.add(orderBy);
    searchInputController.add(searchInputModel);
  }

  void dispose() {
    searchList.close();
    orderByController.close();
    searchInputController.close();
    networkState.close();
  }
}
