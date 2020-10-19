import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../models/my/order_list_page_model.dart';
import '../../states/network_state.dart';

class MyOrderBloc {
  MyOrderBloc({
    this.first,
  }) {
    var dateTime = DateTime.now();
    final year = dateTime.year;
    selectedYear.add('$year');
    networkState.add(NetworkState.Start);

    fetch();
  }

  int first;
  String lastCursor;
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  OrderListByGroupProvider orderListProvider = OrderListByGroupProvider();
  final BehaviorSubject<List<MyOrderPageModel>> repoList =
      BehaviorSubject<List<MyOrderPageModel>>();

  final BehaviorSubject<String> selectedYear = BehaviorSubject<String>();

  List<MyOrderPageModel> _listAll = <MyOrderPageModel>[];

  void getMoreOrder() {
    orderConnection(first, lastCursor, selectedYear.value, true).then((data) {
      print(_listAll);
      _listAll.addAll(data);
      repoList.add(_listAll);
      if (data.isNotEmpty) {
        lastCursor = data[data.length - 1].cursor;
      }
      if (data.length < first) {
        networkState.add(NetworkState.Finish);
      } else {
        networkState.add(NetworkState.Normal);
      }
    });
  }

  Future<bool> fetch() {
    return orderConnection(first, '', selectedYear.value, true).then((data) {
      repoList.add(data);
      if (data.isNotEmpty) {
        lastCursor = data[data.length - 1].cursor;
        _listAll = data;
      }
      if (data.length < first) {
        networkState.add(NetworkState.Finish);
      } else {
        networkState.add(NetworkState.Normal);
      }

      return true;
    });
  }

  void selectYear(String newValue) {
    selectedYear.add(newValue);
  }

  Future<List<MyOrderPageModel>> orderConnection(
      int first, String cursor, String year, bool isFetch) {
    return orderListProvider
        .orderConnection(first, cursor, year, isFetch)
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: fetch)
            });
  }
}
