import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../core.dart';
import '../models/reservation/reservation_page_model.dart';
import '../providers/order/order_list_provider.dart';
import '../states/network_state.dart';

class ReservationPageBloc {
  ReservationPageBloc() {
    fetch();
  }

  final BehaviorSubject<String> lastCursor = BehaviorSubject<String>();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  OrderListProvider orderListProvider = OrderListProvider();
  final BehaviorSubject<List<ReservationPageModel>> repoList =
      BehaviorSubject<List<ReservationPageModel>>();

  Future<List<ReservationPageModel>> fetch() {
    networkState.add(NetworkState.Start);
    //refresh
    return orderConnection(10, '', true).then((data) {
      networkState.add(NetworkState.Normal);
      repoList.add(data);
      if (data.isNotEmpty) {
        lastCursor.add(data[data.length - 1].cursor);
      }
      return data;
    });
  }

  Future<List<ReservationPageModel>> orderConnection(
      int first, String cursor, bool isFetch) {
    return orderListProvider
        .orderConnection(first, cursor, isFetch)
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: fetch)
            });
  }
}
